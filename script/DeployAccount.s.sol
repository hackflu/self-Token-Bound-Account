// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {MyAccount as TBA} from "../src/MyAccount.sol";
import {Script} from "forge-std/Script.sol";

contract DeployAccount is Script{
    function run() public returns(address){
        vm.startBroadcast();
        address account = address(new TBA());
        vm.stopBroadcast();
        return account;

    }
}