// SPDX-License-Identifier: No license
pragma solidity ^0.8.16;

import "./Entidades.sol";
import "./ContractERC20.sol";

abstract contract Seleccion is Entidades, ERC20 {
    uint256 public asientos = 3;
    uint256 weigth = 1;

    function election() public returns (address[] memory) {
        require(
            listaCandidatos.length >= asientos,
            "Numero de candidatos inferior al numero de asientos"
        );
        address[] memory elegidos = new address[](asientos);
        elegidos[0] = calculate_init_score();
        for (uint256 i = 0; i < asientos - 1; i++) {
            for (uint256 j = 0; j < Plazas; j++) {}
        }
        return elegidos;
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
