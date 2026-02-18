// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Create2} from "@openzeppelin/contracts/utils/Create2.sol";
import {IERC6551Registry} from "./interface/IERC6551Registry.sol";


contract Registry is IERC6551Registry {
    // error
    error Registry_Create2Failed();
    function createAccount(
        address implementation,
        bytes32 salt,
        uint256 chainId,
        address tokenContract,
        uint256 tokenId
    ) external returns (address account){
        // 1. create the codeHash 
        bytes memory codeHash = _createAccount(implementation , chainId , tokenContract, tokenId);
        // 2 . CREATE2 is deterministic so it can predict the address before
        account = Create2.computeAddress(salt , keccak256(codeHash)); 
        // check the address is already deployed
        if(account.code.length != 0) return account;
    
        account = Create2.deploy(0 , salt , codeHash);

        emit ERC6551AccountCreated(
            account,
            implementation,
            salt,
            chainId,
            tokenContract,
            tokenId
        );

        return account;


    }

    function account(
        address implementation,
        bytes32 salt,
        uint256 chainId,
        address tokenContract,
        uint256 tokenId
    ) external view returns (address _account){
        bytes memory codeHash = _createAccount(implementation, chainId, tokenContract, tokenId);
        _account = Create2.computeAddress(salt , keccak256(codeHash));
    }

    function _createAccount(address implementation, uint256 chainId, address tokenContract, uint256 tokenId) internal pure returns(bytes memory){
        return abi.encodePacked(
            hex"3d60ad80600a3d3981f3363d3d373d3d3d363d73",
            implementation,
            hex"5af43d82803e903d91602b57fd5bf3",
            abi.encode(chainId , tokenContract, tokenId)
        );
    }
}