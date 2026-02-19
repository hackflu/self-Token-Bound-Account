
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Nft is ERC721 ,ERC721URIStorage,Ownable{
    //error
    error nft_UserAlreadyExist(uint256);

    constructor(address initalOwner) ERC721("Moto" , "MOTO") Ownable(initalOwner){}

    function mint(address to , uint256 tokenId , string calldata tokenUri) public onlyOwner{
        address owner = _ownerOf(tokenId);
        if(owner != address(0)){
            revert nft_UserAlreadyExist(tokenId);
        }
        // _safeMint will revert if the tokenId already exists.
        // Consider adding an `onlyOwner` modifier if minting should be restricted.
        _safeMint(to, tokenId);
        _setTokenURI(tokenId , tokenUri);
        emit Transfer(msg.sender , to, tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage)  returns (string memory) {
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