// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { Test } from "forge-std/Test.sol";
import { MintBasicNft } from "../../script/Interactions.s.sol";
import { BasicNft } from "../../src/BasicNft.sol";
import { DeployBasicNft } from "../../script/DeployBasicNft.s.sol";


contract InteractionsTest is Test {
    MintBasicNft private _mintBasicNft;
    BasicNft private _basicNft;
    DeployBasicNft private _deployer;

    function setUp() public {
        _deployer = new DeployBasicNft();
        _basicNft = _deployer.run();
        _mintBasicNft = new MintBasicNft();
    }

    function testMintsNftFromAddress() public {
        uint256 startingTokenCount = _basicNft.getTokenCounter();

        _mintBasicNft.mintNftOnContract(address(_basicNft));

        assert(_basicNft.getTokenCounter() == startingTokenCount + 1);
    }
}