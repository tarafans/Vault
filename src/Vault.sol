// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/token/ERC20/ERC20.sol";

abstract contract ERC4626 is ERC20 {
    IERC20 asset;

    constructor(IERC20 asset_) {
        asset = asset_;
    }

    function totalAssets() public view returns (uint256) {
        return asset.balanceOf(address(this));
    }

    function convertToShares(uint256 assets) public view returns (uint256) {
        if (totalAssets() == 0) {
            return assets;
        }
        return totalSupply() * assets / totalAssets();
    }

    function convertToAssets(uint256 shares) public view returns (uint256) {
        return totalAssets() * shares / totalSupply();
    }

    function deposit(uint256 assets) public {
        _mint(msg.sender, convertToShares(assets));
        asset.transferFrom(msg.sender, address(this), assets);
    }

    function burn(uint256 shares) public {
        _burn(msg.sender, shares);
        asset.transfer(msg.sender, convertToAssets(shares));
    }
}

contract Vault is ERC4626 {
    constructor(IERC20 asset_) ERC4626(asset_) ERC20("VAULT", "VLT") {
        asset = asset_;
    }
}