// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "./Entidades.sol";

contract ERC20 is Entidades{

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;
/**
*   Variables de estado del contrato
*/
    uint256 private _totalSupply;
    uint256 public _asientos;
    uint256 weigth = 1;
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    address[] public elegidos;

    constructor(string memory name_, string memory symbol_, uint256 asientos_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = 0;
        _asientos = asientos_;
        registerAddress2(0x58954099FA98b6FB59647e5c4804c7aa40455cF2, "Idi Amin");
        registerAddress2(0x149005A8c7cDc49bC2237e4fB93e3eB687d57eAb, "Stalin");
        registerAddress2(0x830f5A0fB328831a645E993ad0305F7213f640FC, "Kim Jong Un");
        registerAddress2(0x249Bfc4F95425243a4C3F536097a445B91Db3417, "Gadafi");
    }

    /**
     * Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * Returns the symbol of the token, usually a shorter version of the name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    /**
     * Devuelve la cantidad total
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     * Devuelve el balance de una cuenta
     */
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    /**
     * Transferencia de tokens
     *
     * - `recipient` = cuenta destino.
     * - `amount` = cantidad a traspasar.
     */
    function Vote(address recipient, uint256 amount)
        public
        virtual
        returns (bool)
    {
        _vote(msg.sender, recipient, amount);
        return true;
    }

    /**
     * Mueve tokens del emisario al receptor.
     *
     * Validaciones:
     *
     * - `sender` no puede ser la dirección 0.
     * - `recipient` no puede ser la dirección 0.
     * - `sender` debe tener un saldo mayor que el amount.
     */
    function _vote(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(balanceOf(sender) >= amount, "Saldo insuficiente");

        _balances[sender] = _balances[sender] - amount;
        _balances[recipient] = _balances[recipient] + amount;

        voters[sender].voto.push(recipient);
        voters[sender].load = 0;
        candidates[recipient].votantes.push(sender);
        candidates[recipient].voterBudget[sender] = amount;
    }

    /**
     * Configuracion de decimales
     */
    function _setupDecimals(uint8 decimals_) internal {
        _decimals = decimals_;
    }

    /** Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply + amount;
        _balances[account] = _balances[account] + amount;
    }

    function showElegidos() public view returns (string[] memory) {
        address[] memory maddress = new address[](elegidos.length);
        string[] memory melegidos = new string[](elegidos.length);
        for (uint256 i = 0; i < elegidos.length; i++) {
            maddress[i] = elegidos[i];
            melegidos[i] = candidates[maddress[i]].name;
        }
        return melegidos;
    }

    function election() public{
        require(
            listaCandidatos.length >= _asientos,
            "Numero de candidatos inferior al numero de asientos"
        );
        elegidos[0] = calculate_init_score();
        for (uint256 i = 1; i < _asientos-1; i++) {
            elegidos[i] = calculate_score_it();
        }
    }

    /**
     *   Cálculo de los pesos iniciales que es 1/stake (votos recibidos en amount de tokens)
     *   tambien se devuelve el ganador de la primera ronda
     */
    function calculate_init_score() public returns (address) {
        address[] memory maddress = new address[](listaCandidatos.length);
        address ganador1 = listaCandidatos[0];
        for (uint256 i = 0; i < Plazas; i++) {
            maddress[i] = listaCandidatos[i];
            candidates[maddress[i]].score = 1 / balanceOf(maddress[i]);
            if (candidates[maddress[i]].score <= 1 / balanceOf(ganador1)) {
                ganador1 = maddress[i];
            }
        }
        candidates[ganador1].electo = true;
        //Calcular el voter load de los votantes
        for (uint256 i = 0; i < candidates[ganador1].votantes.length; i++) {
            voters[candidates[ganador1].votantes[i]].load = candidates[ganador1].score;
        }
        return ganador1;
    }

    /**
     *   Cálculo de los pesos iniciales que es 1/stake (votos recibidos en amount de tokens)
     */
    function calculate_score_it() public returns (address) {
        address[] memory maddress = new address[](listaCandidatos.length);
        address ganador;
        for (uint256 i = 0; i < Plazas; i++) {
            maddress[i] = listaCandidatos[i];
            //candidate_score = candidate_score + ((voter_budget * voter_load) / candidate_approval_stake)
            for (uint j = 0; j < candidates[maddress[i]].votantes.length; j++){
                if(candidates[maddress[i]].electo != true){
                    address vaddress = candidates[maddress[i]].votantes[j];
                    candidates[maddress[i]].score = candidates[maddress[i]].score + (voters[vaddress].load * candidates[maddress[i]].voterBudget[vaddress]) / balanceOf(maddress[i]);
                }
            }
            if (candidates[maddress[i]].score <= 1 / balanceOf(ganador)) {
                ganador = maddress[i];
            }

        }
        //Calcular el voter load de los votantes
        for (uint256 i = 0; i < candidates[ganador].votantes.length; i++) {
            voters[candidates[ganador].votantes[i]].load = candidates[
                ganador
            ].score;
        }
        return ganador;
    }
}
