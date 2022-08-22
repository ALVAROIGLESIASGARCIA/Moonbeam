// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "./ContractERC20.sol";

// This ERC-20 contract mints the specified amount of tokens to the contract creator.
contract Votacion is ERC20 {
    constructor(uint256 initialSupply) ERC20("Votacion", "VOTOS", 3) {
        _mint(msg.sender, initialSupply);
        _mint(0xfA055C249d1609efb3340B84Bed2c80206203aE1, 4);
        _mint(0x93858492198d0c9E4a6FB7f7A8D2cE7b824F2595, 3);
        _mint(0x4E868D58667245f7FE0026679E235b080Af67B9a, 12);
        _mint(0xEAc16CDbc9901920d90bE4808D38aA73Db8CA5Eb, 20);
    }
}
