// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

abstract contract WithDroid {
	address public droid;
	address public treasury;
	address public pendingDroid;
	uint256 public currentEdition;
	uint256 public editionBumpThreshold;
	uint256 public defaultEditionBumpInterval = 31 days;

	constructor() {
		droid = msg.sender;
		treasury = msg.sender;
		editionBumpThreshold = block.timestamp + defaultEditionBumpInterval;
	}

	modifier onlyDroid() {
		require(msg.sender == droid, "!owner");
		_;
	}
	modifier onlyPendingDroid() {
		require(msg.sender == pendingDroid, "!authorized");
		_;
	}

	/*******************************************************************************
	**  @notice
	**    Nominate a new address to use as Droid.
	**    The change does not go into effect immediately. This function sets a
	**    pending change, and the management address is not updated until
	**    the proposed Droid address has accepted the responsibility.
	**    This may only be called by the current Droid address.
	**  @param _droid The address requested to take over the role.
	*******************************************************************************/
	function setDroid(address _droid) public onlyDroid() {
		pendingDroid = _droid;
	}

	/*******************************************************************************
	**  @notice
	**    Once a new droid address has been proposed using setDroid(),
	**    this function may be called by the proposed address to accept the
	**    responsibility of taking over the role for this contract.
	**    This may only be called by the proposed Droid address.
	**  @dev
	**    setDroid() should be called by the existing droid address,
	**    prior to calling this function.
	*******************************************************************************/
	function acceptDoid() public onlyPendingDroid() {
		droid = msg.sender;
	}

	/*******************************************************************************
	**  @notice
	**    Nominate a new address to use as treasury. . Can only be called by
	**    the Droid.
	**    The change goes into effect immediately.
	**  @param _treasury The address requested to take over the role.
	*******************************************************************************/
	function setTreasury(address _treasury) public onlyDroid() {
		treasury = _treasury;
	}

	/*******************************************************************************
	**  @notice
	**    Increment the edition. Can only be called by the Droid.
	**    The change goes into effect immediately.
	*******************************************************************************/
	function bumpEdition(uint256 bumpDaysThreshold) public onlyDroid() {
		currentEdition++;
		editionBumpThreshold = block.timestamp + (bumpDaysThreshold * 1 days);
	}

	/*******************************************************************************
	**  @notice
	**    Set the default edition bump interval. Can only be called by the Droid.
	**    The change goes into effect immediately.
	*******************************************************************************/
	function setDefaultEditionBumpInterval(uint256 editionBumpInterval) public onlyDroid() {
		defaultEditionBumpInterval = (editionBumpInterval * 1 days);
	}
}
