// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { Test } from "forge-std/Test.sol";
import { BasicNft } from "../../src/BasicNft.sol";
import { DeployBasicNft } from "../../script/DeployBasicNft.s.sol";

contract BasicNftTest is Test {
    DeployBasicNft public deployer;
    BasicNft public basicNft;

    function setUp() public {
        deployer = new DeployBasicNft();
    }

    function testDeploysAndReturnsBasicNft() public {
        basicNft = deployer.run();
        assert(address(basicNft) != address(0));
    }
}