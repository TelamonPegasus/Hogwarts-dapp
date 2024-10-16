const hre = require("hardhat");

const vrfCoordinatorV2Address = process.env.VRFaddress;
const subId = process.env.SubId;
const keyHash = process.env.keyHash;
const gasLimit = 2500000; // Set the gas limit you want to use

async function main() {
  console.log("Deploying Hogwarts NFT Contract...");

  const HogwartsNFT = await hre.ethers.getContractFactory("HogwartsNFT");
  const hogwartsNFT = await HogwartsNFT.deploy();

  let currentBlock = await hre.ethers.provider.getBlockNumber();
  while (currentBlock + 5 > (await hre.ethers.provider.getBlockNumber())) {}

  const hogwartsAddress = await hogwartsNFT.getAddress();
  console.log("Hogwarts NFT deployed to:", hogwartsAddress);

  console.log("Deploying Random House Assignment Contract...");

  const RandomHouse = await hre.ethers.getContractFactory("RandomHouseAssignment");

  // Deploy with overrides: gasLimit as part of an object
  const randomHouse = await RandomHouse.deploy(
    hogwartsAddress,
    vrfCoordinatorV2Address,
    subId,
    keyHash,
    { gasLimit } // Correctly passing the overrides as an object
  );

  while (currentBlock + 5 > (await hre.ethers.provider.getBlockNumber())) {}

  const randomAddress = await randomHouse.getAddress();
  console.log("Random House Assignment deployed to:", randomAddress);

  // Transferring ownership
  await hogwartsNFT.transferOwnership(randomAddress);
  console.log("Ownership transferred");
}

main().catch((error) => {
  console.error("Deployment error:", error);
  process.exit(1);
});

