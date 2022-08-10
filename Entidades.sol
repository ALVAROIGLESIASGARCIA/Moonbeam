// SPDX-License-Identifier: No license
pragma solidity ^0.8.16;

/**
 *
 *   El siguiente código declara las estructuras necesarias para llevar a cabo el objetivo
 *   Tales estructuras son:
 *   Candidato:
 *   Votante:
 *
 */
contract Entidades {
    struct Candidato {
        string name;
        address[] votantes;
        mapping(address => uint256) voterBudget;
        bool electo;
        uint256 score;
    }

    // Declara una variable de estado que
    // almacena una estructura de datos `Candidato` para cada posible dirección.
    mapping(address => Candidato) public candidates;
    address[] public listaCandidatos;

    struct Voter {
        address[] voto;
        uint256 load;
    }

    // Declara una variable de estado que
    // almacena una estructura de datos `Voter` para cada posible dirección.
    mapping(address => Voter) public voters;

    /**Numero de plazas
     */
    uint256 public Plazas = 5;

    /**Añade un candidato hasta un maximo de x
     */
    function registerAddress(address candidateDir, string calldata _name) public {
        require(
            listaCandidatos.length <= Plazas,
            "Maximo de candidatos alcanzado"
        );
        candidates[candidateDir].name = _name;
        listaCandidatos.push(candidateDir);
    }

    function showCandidates() public view returns (string[] memory) {
        address[] memory maddress = new address[](listaCandidatos.length);
        string[] memory mcandidate = new string[](listaCandidatos.length);
        for (uint256 i = 0; i < listaCandidatos.length; i++) {
            maddress[i] = listaCandidatos[i];
            mcandidate[i] = candidates[maddress[i]].name;
        }
        return mcandidate;
    }
}
