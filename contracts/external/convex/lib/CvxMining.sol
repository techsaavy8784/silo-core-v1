// SPDX-License-Identifier: MIT
// Original Copyright 2021 convex-eth
// Original source: https://github.com/convex-eth/platform/blob/669033cd06704fc67d63953078f42150420b6519/contracts/contracts/interfaces/CvxMining.sol
pragma solidity 0.6.12;

import "../interfaces/ICvx.sol";

library CvxMining{
    ICvx public constant cvx = ICvx(0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B);

    function ConvertCrvToCvx(uint256 _amount) external view returns(uint256){
        uint256 supply = cvx.totalSupply();
        uint256 reductionPerCliff = cvx.reductionPerCliff();
        uint256 totalCliffs = cvx.totalCliffs();
        uint256 maxSupply = cvx.maxSupply();

        uint256 cliff = supply / reductionPerCliff;
        //mint if below total cliffs
        if(cliff < totalCliffs){
            //for reduction% take inverse of current cliff
            uint256 reduction = totalCliffs - cliff;
            //reduce
            _amount = _amount * reduction / totalCliffs;

            //supply cap check
            uint256 amtTillMax = maxSupply - supply;
            if(_amount > amtTillMax){
                _amount = amtTillMax;
            }

            //mint
            return _amount;
        }
        return 0;
    }
}
