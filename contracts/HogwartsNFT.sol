// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract HogwartsNFT is ERC721URIStorage, Ownable {
    mapping(uint256 => address) public s_requestIdToSender;
    mapping(address => uint256) public s_addressToHouse;
    mapping(address => bool) public hasMinted;
    mapping(address => string) public s_addressToName;

    uint256 private s_tokenCounter;

    string[] internal houseTokenURIs = [
        "ipfs://QmXja2QBKsNW9qnw9kKfcm25rJTomwAVJUrXekYFJnVwbg/Gryffindor.json",-
        "ipfs://QmXja2QBKsNW9qnw9kKfcm25rJTomwAVJUrXekYFJnVwbg/Hufflepuff.json",
        "ipfs://QmXja2QBKsNW9qnw9kKfcm25rJTomwAVJUrXekYFJnVwbg/Ravenclaw.json",
        "ipfs://QmXja2QBKsNW9qnw9kKfcm25rJTomwAVJUrXekYFJnVwbg/Slytherin.json"
    ];

    event NftMinted(uint256 house, address minter, string name);

    constructor() ERC721("Hogwarts NFT", "HOG") ownable {
        s_tokenCounter = 0;
    }

    function hasMintedNFT(address _user) public view returns (bool) {
        return hasMinted[_user];
    }

    function getHouseIndex(address _user) public view returns (uint256) {
        return s_addressToHouse[_user];
    }

    function mintNFT(address recipient, uint256 house, string memory name) external onlyOwner {
        require(!hasMinted[recipient], "You have already minted your house NFT"); // Ensure the address has not minted before

        uint256 tokenId = s_tokenCounter;
        _safeMint(recipient, tokenId);
        _setTokenURI(tokenId, houseTokenURIs[house]);

        s_addressToHouse[recipient] = house; //map house to address
        s_addressToName[recipient] = name; // map name to address

        s_tokenCounter += 1;
        hasMinted[recipient] = true; // Mark the address as having minted an NFT

        emit NftMinted(house, recipient, name);
    }

}
