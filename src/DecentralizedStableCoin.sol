// SPDX-License-Identifier: MIT

pragma solidity 0.8.33;

import {ERC20Burnable, ERC20} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/*
 * @title DecentralizedStableCoin
 * Collateral: Exogenous
 * Minting (Stability Mechanism): Decentralized (Algorithmic)
 * Value (Relative Stability): Anchored (Pegged to USD)
 * Collateral Type: Crypto
 *
 * This is the contract meant to be owned by DSCEngine. It is an ERC20 token that can be minted and burned by the DSCEngine smart contract.
 */

contract DecentralizedStableCoin is ERC20Burnable, Ownable {
    error DecentralizedStableCoin_MustBePositive();
    error DecentralizedStableCoin_BurnAmountExceedsBalance();
    error DecentralizedStableCoin_ZeroAddressNotAllowed();

    constructor()
        ERC20("DecentralizedStableCoin", "DSC")
        Ownable(msg.sender)    
    {}

    function burn(uint256 _amount) public override onlyOwner {
        uint balance = balanceOf(msg.sender);
        if(_amount <= 0) revert DecentralizedStableCoin_MustBePositive();
        if(balance < _amount) revert DecentralizedStableCoin_BurnAmountExceedsBalance();

        super.burn(_amount);
    }

    function mint(address _to, uint256 _amount) external onlyOwner returns(bool) {
        if(_to == address(0)) revert DecentralizedStableCoin_ZeroAddressNotAllowed();
        if(_amount <= 0) revert DecentralizedStableCoin_MustBePositive();

        _mint(_to, _amount);
        return true;
    }
}