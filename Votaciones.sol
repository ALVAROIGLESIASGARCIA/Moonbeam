// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "./ABDKMath64x64.sol";

contract ContractERC20 {
    using ABDKMath64x64 for int128;

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

        registerAddress2(0x58954099FA98b6FB59647e5c4804c7aa40455cF2, "A");
        registerAddress2(0x149005A8c7cDc49bC2237e4fB93e3eB687d57eAb, "B");
        registerAddress2(0x830f5A0fB328831a645E993ad0305F7213f640FC, "C");
        registerAddress2(0x249Bfc4F95425243a4C3F536097a445B91Db3417, "D");

        _mint(0x436C5FDDAf8504a7cABf9fe1465DbCf85A76d3cC, 2);
        _mint(0xfA055C249d1609efb3340B84Bed2c80206203aE1, 4);
        _mint(0x93858492198d0c9E4a6FB7f7A8D2cE7b824F2595, 3);
        _mint(0x4E868D58667245f7FE0026679E235b080Af67B9a, 12);
        _mint(0xEAc16CDbc9901920d90bE4808D38aA73Db8CA5Eb, 20);
    }

    uint256 Plazas = 4;

    /**
 *
 *   El siguiente código declara las estructuras necesarias para llevar a cabo el objetivo
 *   Tales estructuras son:
 *   Candidato:
 *   Votante:
 *
 */
    address[] listaCandidatos;

    struct candidate {
      address[] votantes;
      mapping(address => uint256) voterBudget;
      string name;
      int128 score;
      bool electo;     
    }

    struct voter {
      address[] voto;
      int128 load;
    }

    // Declara una variable de estado que
    // almacena una estructura de datos `Candidato` para cada posible dirección.
    mapping(address => candidate) candidates;
    mapping(address => voter) voters;

    mapping(address => string) registry;

    /**Añade un candidato hasta un maximo de x
     */
    function registerAddress(address candidateDir, string calldata name_) public {
        require(
            listaCandidatos.length <= Plazas,
            "Maximo de candidatos alcanzado"
        );
        candidates[candidateDir].name = name_;
        listaCandidatos.push(candidateDir);
    }

    function registerAddress2(address candidateDir, string memory name_) public {
        require(
            listaCandidatos.length <= Plazas,
            "Maximo de candidatos alcanzado"
        );
        candidates[candidateDir].name = name_;
        listaCandidatos.push(candidateDir);
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
    function Vote(address recipient, uint256 amount)public virtual returns (bool)
    {
        _vote(msg.sender, recipient, amount);
        return true;
    }
    /**
    *Autovoto para pruebas
    */
    function VoteAuto() public virtual returns (bool)
    {
        /**
        Votos A
        */
        _vote(0x436C5FDDAf8504a7cABf9fe1465DbCf85A76d3cC, 0x58954099FA98b6FB59647e5c4804c7aa40455cF2, 1);
        _vote(0xfA055C249d1609efb3340B84Bed2c80206203aE1, 0x58954099FA98b6FB59647e5c4804c7aa40455cF2, 2);
        _vote(0x93858492198d0c9E4a6FB7f7A8D2cE7b824F2595, 0x58954099FA98b6FB59647e5c4804c7aa40455cF2, 3);
        _vote(0xEAc16CDbc9901920d90bE4808D38aA73Db8CA5Eb, 0x58954099FA98b6FB59647e5c4804c7aa40455cF2, 5);
        /**
        Votos B
        */
        _vote(0x436C5FDDAf8504a7cABf9fe1465DbCf85A76d3cC, 0x149005A8c7cDc49bC2237e4fB93e3eB687d57eAb, 1);
        _vote(0xfA055C249d1609efb3340B84Bed2c80206203aE1, 0x149005A8c7cDc49bC2237e4fB93e3eB687d57eAb, 2);
        _vote(0x4E868D58667245f7FE0026679E235b080Af67B9a, 0x149005A8c7cDc49bC2237e4fB93e3eB687d57eAb, 4);
        /**
        Votos C
        */
        _vote(0x4E868D58667245f7FE0026679E235b080Af67B9a, 0x830f5A0fB328831a645E993ad0305F7213f640FC, 4);
        /**
        Votos D
        */
        _vote(0x4E868D58667245f7FE0026679E235b080Af67B9a, 0x249Bfc4F95425243a4C3F536097a445B91Db3417, 4);
        _vote(0xEAc16CDbc9901920d90bE4808D38aA73Db8CA5Eb, 0x249Bfc4F95425243a4C3F536097a445B91Db3417, 5);
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
    function _vote(address sender,address recipient,uint256 amount) internal virtual
    {
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

    function percentage(uint256 balanceAmount) internal virtual returns (int128)
    {
        return ABDKMath64x64.divu(1, balanceAmount);
    }

    function election() public{
        require(
            listaCandidatos.length >= _asientos,
            "Numero de candidatos inferior al numero de asientos"
        );
        elegidos.push(calculate_init_score());
        for (uint256 i = 1; i < _asientos; i++) {
            elegidos.push(calculate_score_it());
        }
    }

    /**
     *   Cálculo de los pesos iniciales que es 1/stake (votos recibidos en amount de tokens)
     *   tambien se devuelve el ganador de la primera ronda
     */
    function calculate_init_score() public returns (address) {
        address ganador1 = listaCandidatos[0];
        for (uint256 i = 0; i < listaCandidatos.length; i++) {
            candidates[listaCandidatos[i]].score = percentage(balanceOf(listaCandidatos[i]));
            if (candidates[listaCandidatos[i]].score <= percentage(balanceOf(ganador1)))
            {
                ganador1 = listaCandidatos[i];
            }
        }

        candidates[ganador1].electo = true;

        //Calcular el voter load de los votantes
        for (uint256 i = 0; i < candidates[ganador1].votantes.length; i++) {
            voters[candidates[ganador1].votantes[i]].load = candidates[ganador1].score;
        }

        return ganador1;
    }

    function calculate_score_it() public returns (address) {
        uint256 countPotential = 0;
        address[] memory potentialCandidatos = new address[](listaCandidatos.length);
        for (uint256 i = 0; i < listaCandidatos.length; i++) {
            if(candidates[listaCandidatos[i]].electo != true) {
                potentialCandidatos[countPotential] = listaCandidatos[i];
                countPotential++;
            }
        }

        for (uint256 i = 0; i < listaCandidatos.length; i++) {
            candidates[listaCandidatos[i]].score = percentage(balanceOf(listaCandidatos[i]));

            //candidate_score = candidate_score + ((voter_budget * voter_load) / candidate_approval_stake)
            for (uint j = 0; j < candidates[listaCandidatos[i]].votantes.length; j++){
                if(candidates[listaCandidatos[i]].electo != true) {
                    address vaddress = candidates[listaCandidatos[i]].votantes[j];
                    candidates[listaCandidatos[i]].score = candidates[listaCandidatos[i]].score.add(
                        voters[vaddress].load.mul(
                            ABDKMath64x64.fromUInt(candidates[listaCandidatos[i]].voterBudget[vaddress])
                        ).div(
                            ABDKMath64x64.fromUInt(balanceOf(listaCandidatos[i]))
                        )
                    );
                }
            }
        }

        address ganador = potentialCandidatos[0];
        for (uint256 i = 0; i < potentialCandidatos.length; i++) {
            if (potentialCandidatos[i] == address(0)) {
                break;
            }

            if (candidates[potentialCandidatos[i]].score <= candidates[ganador].score) {
                ganador = potentialCandidatos[i];
            }
        }

        candidates[ganador].electo = true;

        //Calcular el voter load de los votantes
        for (uint256 i = 0; i < candidates[ganador].votantes.length; i++) {
            voters[candidates[ganador].votantes[i]].load = candidates[ganador].score;
        }

        return ganador;
    }


}
