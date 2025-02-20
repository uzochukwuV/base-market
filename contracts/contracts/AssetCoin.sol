//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// Useful for debugging. Remove when deploying to a live network.
import "hardhat/console.sol";

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract AssetCoin is ERC20, Ownable, ERC20Permit {
    constructor(address initialOwner)
        ERC20("AssetCoin", "CCN")
        Ownable(initialOwner)
        ERC20Permit("AssetCoin")
    {
        _mint(initialOwner, 1999999 * 10 ** decimals());
    }

    function safeMint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
