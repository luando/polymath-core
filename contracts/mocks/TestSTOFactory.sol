pragma solidity ^0.4.24;

import "../modules/STO/DummySTO.sol";
import "../modules/ModuleFactory.sol";
import "../helpers/Util.sol";

contract TestSTOFactory is ModuleFactory {

    /**
     * @notice Constructor
     * @param _polyAddress Address of the polytoken
     */
    constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public
      ModuleFactory(_polyAddress, _setupCost, _usageCost, _subscriptionCost)
    {
        version = "1.0.0";
        name = "TestSTO";
        title = "Test STO";
        description = "Test STO";
    }

     /**
     * @notice used to launch the Module with the help of factory
     * @param _data Data used for the intialization of the module factory variables
     * @return address Contract address of the Module
     */
    function deploy(bytes _data) external returns(address) {
        if(setupCost > 0)
            require(polyToken.transferFrom(msg.sender, owner, setupCost), "Failed transferFrom because of sufficent Allowance is not provided");
        //Check valid bytes - can only call module init function
        DummySTO dummySTO = new DummySTO(msg.sender, address(polyToken));
        //Checks that _data is valid (not calling anything it shouldn't)
        require(Util.getSig(_data) == dummySTO.getInitFunction(), "Provided data is not valid");
        require(address(dummySTO).call(_data), "Un-successfull call");
        return address(dummySTO);
    }

    /**
     * @notice Type of the Module factory
     */
    function getType() public view returns(uint8) {
        return 3;
    }

    /**
     * @notice Get the name of the Module
     */
    function getName() public view returns(bytes32) {
        return name;
    }

    /**
     * @notice Get the description of the Module
     */
    function getDescription() public view returns(string) {
        return description;
    }

    /**
     * @notice Get the title of the Module
     */
    function getTitle() public view returns(string) {
        return title;
    }

    /**
     * @notice Get the version of the Module
     */
    function getVersion() external view returns(string) {
        return version;
    }

    /**
     * @notice Get the setup cost of the module
     */
    function getSetupCost() external view returns (uint256) {
        return setupCost;
    }

    /**
     * @notice Get the Instructions that helped to used the module
     */
    function getInstructions() public view returns(string) {
        return "Test STO - you can mint tokens at will";
    }

    /**
     * @notice Get the tags related to the module factory
     */
    function getTags() public view returns(bytes32[]) {
        bytes32[] memory availableTags = new bytes32[](4);
        availableTags[0] = "Test";
        availableTags[1] = "Non-refundable";
        availableTags[2] = "ETH";
        return availableTags;
    }

}
