// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

// deployed address: 0xB6a94B121C34B11dd5D806101d787781b4F1e586
// minted version: 0xb6a94b121c34b11dd5d806101d787781b4f1e586

// deployed extra address: 0xADB6bF0d3Bd8c740ad0Eb7CBcE037aeBA72f7a9e

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter; 
    Counters.Counter private _tokenIds;

    mapping(uint256 => Warrior) public tokenIdToLevels;

    struct Warrior {
        uint256 level;
        uint256 speed;
        uint256 strength;
        uint256 life;
    }

    constructor() ERC721 ("Chain Battles", "CBTLS"){

    }

    function generateCharacter(uint256 tokenId) public view returns(string memory){

        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",getLevels(tokenId),'</text>',
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Speed: ",getSpeed(tokenId),'</text>',
            '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Strength: ",getStrength(tokenId),'</text>',
            '<text x="50%" y="80%" class="base" dominant-baseline="middle" text-anchor="middle">', "Life: ",getLife(tokenId),'</text>',
            '</svg>'
        );
        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
            )    
        );


    }

    function getLevels(uint256 tokenId) public view returns (string memory) {
        uint256 levels = tokenIdToLevels[tokenId].level;
        return levels.toString();
    }

    function getSpeed(uint256 tokenId) public view returns (string memory) {
        uint256 speed = tokenIdToLevels[tokenId].speed;
        return speed.toString();
    }

    function getStrength(uint256 tokenId) public view returns (string memory) {
        uint256 strength = tokenIdToLevels[tokenId].strength;
        return strength.toString();
    }

    function getLife(uint256 tokenId) public view returns (string memory) {
        uint256 life = tokenIdToLevels[tokenId].life;
        return life.toString();
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory){
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "Chain Battles #', tokenId.toString(), '",',
                '"description": "Battles on chain",',
                '"image": "', generateCharacter(tokenId), '"',
            '}'
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );    
    }

    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenIdToLevels[newItemId] = Warrior(0,0,0,0);
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function rand() public view returns(uint256) {
        uint256 seed = uint256(keccak256(abi.encodePacked(
            block.timestamp + block.difficulty +
            ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (block.timestamp)) +
            block.gaslimit + 
            ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (block.timestamp)) +
            block.number
        )));

        uint256 result = (seed - ((seed / 4) * 4));       

        return result;
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId), "Please use an existing token");
        require(ownerOf(tokenId) == msg.sender, "You must own this token to train it");
        uint256 randomNumber = rand();
        Warrior memory warrior = tokenIdToLevels[tokenId];
        if (randomNumber == 0) {
            uint256 currentLevel = warrior.level;
            warrior.level = currentLevel + 1;
        }
        if (randomNumber == 1) {
            uint256 currentSpeed = warrior.speed;
            warrior.speed = currentSpeed + 1;
        }
        if (randomNumber == 2) {
            uint256 currentStrength = warrior.strength;
            warrior.strength = currentStrength + 1;
        }
        if (randomNumber == 3) {
            uint256 currentLife = warrior.life;
            warrior.life = currentLife + 1;
        }
        tokenIdToLevels[tokenId] = warrior;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }



}