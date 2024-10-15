// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./HogwartsNFT.sol";
import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

contract RandomHouseAssignment is VRFConsumerBaseV2Plus {
    HogwartsNFT public nftContract;
    uint256 private s_subscriptionId; // Changed to uint256 as per VRF 2.5
    bytes32 private i_keyHash; 
    uint32 public callbackGasLimit = 250000;
    mapping(uint256 => address) private s_requestIdToSender;
    mapping(address => string) private s_nameToSender;

    event NftRequested(uint256 indexed requestId, address requester);

    constructor(
        address _nftContract,
        uint256 subscriptionId,
        bytes32 keyHash,
        uint32 gasLimit
    ) VRFConsumerBaseV2Plus(0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B) { // Replace with actual VRF Coordinator address
        nftContract = HogwartsNFT(_nftContract);
        s_subscriptionId = subscriptionId;
        i_keyHash = keyHash;
        callbackGasLimit = gasLimit;
    }

    function requestNFT(string memory name) public returns (uint256 requestId) {
        // Use the s_vrfCoordinator from VRFConsumerBaseV2Plus and the new request format for VRF 2.5
        requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: i_keyHash,
                subId: s_subscriptionId,
                requestConfirmations: 3, // Minimum confirmations
                callbackGasLimit: callbackGasLimit,
                numWords: 1, // Request 1 random word
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({nativePayment: false}) // Set nativePayment to false for LINK payment
                )
            })
        );

        s_requestIdToSender[requestId] = msg.sender;
        s_nameToSender[msg.sender] = name;
        emit NftRequested(requestId, msg.sender);
    }

    function fulfillRandomWords(uint256 requestId, uint256[] calldata randomWords) internal override {
        address nftOwner = s_requestIdToSender[requestId];
        string memory name = s_nameToSender[nftOwner];
        uint256 house = randomWords[0] % 4;
        nftContract.mintNFT(nftOwner, house, name);
    }
}

