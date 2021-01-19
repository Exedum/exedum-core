pragma solidity ^0.5.17;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts/access/roles/MinterRole.sol";
import "./Permittable.sol";
import "./IExedum.sol";

contract Exedum is IExedum, MinterRole, ERC20Detailed, Permittable, ERC20Burnable  {

    address _pool;
    uint256 public _fee;


    constructor()
    ERC20Detailed("Exedum", "EXED", 18)
    Permittable()
    public
    {
        _fee = 100; // 1%
    }

    function setPool(address pool) external onlyMinter {
        require(pool == address(0), "Pool already setted");
        _pool = pool;
    }

    function mint(address account, uint256 amount) public onlyMinter returns (bool) {
        _mint(account, amount);
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        if (_pool == address(0)) {
            super._transfer(sender, recipient, amount);
        } else {
            uint256 feeamount = _amount.mul(_fee).div(10000);
            uint256 remamount = _amount.sub(feeamount);
            super._transfer(sender, recipient, remamount);
            super._transfer(sender, _pool, feeamount);
        }
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _transfer(sender, recipient, amount);
        if (allowance(sender, _msgSender()) != uint256(-1)) {
            _approve(
                sender,
                _msgSender(),
                allowance(sender, _msgSender()).sub(amount, "Exedum: transfer amount exceeds allowance"));
        }
        return true;
    }
}
