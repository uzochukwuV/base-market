// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Burnable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";


contract AssetNFT is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
    uint256 private _nextTokenId = 1;
    mapping (address => uint) owners;

    constructor (address initialOwner)
        ERC721("AssetNFT", "Ant")
        Ownable(initialOwner)
    {}

    function safeMint(address to, string memory uri) public {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function getAllUserNFT(address user) public view returns ( uint[] memory){
        uint balance = balanceOf(user);
        uint[] memory tokens = new uint[](balance);
        uint counter = 0;
        for (uint i = 1; i < _nextTokenId; i++) {
            if (ownerOf(i) == user) {
                tokens[counter] = i;
                counter++;
            }
        }
        return tokens;
    }

    // The following functions are overrides required by Solidity.

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
