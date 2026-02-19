// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Registry} from "../src/Registry.sol";
import {Script} from "forge-std/Script.sol";

contract DeployRegister is Script{
    function run() public returns(Registry){
        vm.startBroadcast();
        Registry registry = new Registry();
        vm.stopBroadcast();
        return registry;
    }
}