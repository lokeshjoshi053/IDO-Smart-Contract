// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable2Step.sol";

contract IDO is ERC20Permit, ERC20Pausable, AccessControl, Ownable2Step {
    bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
    uint256 public constant cap = 100 * 1000 * 1000 * 1 ether;

    constructor() ERC20("Idexo Token", "IDO") ERC20Permit("Idexo Token") {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(OPERATOR_ROLE, _msgSender());

        _mint(_msgSender(), cap);
        emit OwnershipTransferred(address(0), _msgSender());
    }

//Role

    /**
     * @dev Restricted to members of the operator role.
     */
    modifier onlyOperator() {
        require(hasRole(OPERATOR_ROLE, _msgSender()), "IDO: CALLER_NO_OPERATOR_ROLE");
        _;
    }

    /**
     * @dev Add an account to the operator role.
     * @param account address
     */
    function addOperator(address account) public onlyOwner {
        require(!hasRole(OPERATOR_ROLE, account), "IDO: ALREADY_OERATOR_ROLE");
        grantRole(OPERATOR_ROLE, account);
    }

    /**
     * @dev Remove an account from the operator role.
     * @param account address
     */
    function removeOperator(address account) public onlyOwner {
        require(hasRole(OPERATOR_ROLE, account), "IDO: NO_OPERATOR_ROLE");
        revokeRole(OPERATOR_ROLE, account);
    }

    /**
     * @dev Check if an account is operator.
     * @param account address
     */
    function checkOperator(address account) public view returns (bool) {
        return hasRole(OPERATOR_ROLE, account);
    }

//Token

    /**
     * @dev `_beforeTokenTransfer` hook override.
     * @param from address
     * @param to address
     * @param amount uint256
     * `Owner` can only transfer when paused
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20, ERC20Pausable) {
        if (from == owner()) {
            return;
        }
        ERC20Pausable._beforeTokenTransfer(from, to, amount);
    }

    /**
     * @dev Get chain id.
     */
    function getChainId() public view returns (uint256) {
        uint256 id;
        assembly { id := chainid() }
        return id;
    }

//Pausability 

    /**
     * @dev Pause.
     */
    function pause() public onlyOperator {
        super._pause();
    }

    /**
     * @dev Unpause.
     */
    function unpause() public onlyOperator {
        super._unpause();
    }
}

