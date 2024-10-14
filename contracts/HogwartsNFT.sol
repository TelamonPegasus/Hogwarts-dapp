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
        "ipfs://QmXja2QBKsNW9qnw9kKfcm25rJTomwAVJUrXekYFJnVwbg/Gryffindor.json",
        "ipfs://QmXja2QBKsNW9qnw9kKfcm25rJTomwAVJUrXekYFJnVwbg/Hufflepuff.json",
        "ipfs://QmXja2QBKsNW9qnw9kKfcm25rJTomwAVJUrXekYFJnVwbg/Ravenclaw.json",
        "ipfs://QmXja2QBKsNW9qnw9kKfcm25rJTomwAVJUrXekYFJnVwbg/Slytherin.json"
    ];

    event NftMinted(uint256 house, address minter, string name);

    constructor() ERC721("Hogwarts NFT", "HP") {
        s_tokenCounter = 0;
    }

    function hasMintedNFT(address _user) public view returns (bool) {
        return hasMinted[_user];
    }

}