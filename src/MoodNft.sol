// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { Base64 } from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    error MoodNft__CantFlipMoodIfNotOwner();

    uint256 private _tokenCounter;
    string private _sadSvgImageUri;
    string private _happySvgImageUri;

    enum Mood {
        HAPPY,
        SAD
    }

    mapping(uint256 => Mood) private _tokenIdToMood;

    constructor(
        string memory sadSvgImageUri,
        string memory happySVGImageUri
    ) ERC721("Mood NFT", "MN") {
        _tokenCounter = 0;
        _sadSvgImageUri = sadSvgImageUri;
        _happySvgImageUri = happySVGImageUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, _tokenCounter);
        _tokenIdToMood[_tokenCounter] = Mood.HAPPY;
        _tokenCounter++;
    }

    function flipMood(uint256 tokenId) public {
        if (!_isApprovedOrOwner(msg.sender, tokenId)) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }

        if (_tokenIdToMood[tokenId] == Mood.HAPPY) {
            _tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            _tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageUri;

        if(_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageUri = _happySvgImageUri;
        } else {
            imageUri = _sadSvgImageUri;
        }

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"',
                            name(),
                            '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                            '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                            imageUri,
                            '"}'
                        )
                    )
                )
            )
        );
    }
}