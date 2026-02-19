// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {Script} from "forge-std/Script.sol";
import {Nft} from "../src/Nft.sol";

contract DeployNft is Script {
    function run() public returns(Nft){
        vm.startBroadcast();
        Nft nft = new Nft(msg.sender);
        vm.stopBroadcast();
        return nft;
    }
}