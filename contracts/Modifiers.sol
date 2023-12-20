// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Structure.sol";

contract modi {
    mapping(uint256 => Structure.Ladle) ladles;
    mapping(address => Structure.Roles) roles;
    bool forward=true;
    address owner;

    function hasTLCRole(address _account) public view returns (bool) {
        require(_account != address(0));
        return roles[_account].TLC;
    }

    function addTLCRole(address _account) public {
        require((_account != address(0))&&(msg.sender==owner));
        require(!hasTLCRole(_account));

        roles[_account].TLC = true;
    }

    //Converter
    function hasConverterRole(address _account) public view returns (bool) {
        require((_account != address(0)));
        return roles[_account].Converter;
    }

    function addConverterRole(address _account) public {
        require((_account != address(0))&&(msg.sender==owner));
        require(!hasConverterRole(_account));

        roles[_account].Converter = true;
    }

    //LF-1 
    function hasLF_1Role(address _account) public view returns (bool) {
        require(_account != address(0));
        return roles[_account].LF_1;
    }

    function addLF_1Role(address _account) public {
        require((_account != address(0))&&(msg.sender==owner));
        require(!hasLF_1Role(_account));

        roles[_account].LF_1 = true;
    }

    //LF-2
    function hasLF_2Role(address _account) public view returns (bool) {
        require(_account != address(0));
        return roles[_account].LF_2;
    }

    function addLF_2Role(address _account) public {
        require((_account != address(0))&&(msg.sender==owner));
        require(!hasLF_2Role(_account));

        roles[_account].LF_2 = true;
    }

    //RH
    function hasRHRole(address _account) public view returns (bool) {
        require(_account != address(0));
        return roles[_account].RH;
    }

    function addRHRole(address _account) public {
        require((_account != address(0))&&(msg.sender==owner));
        require(!hasRHRole(_account));

        roles[_account].RH = true;
    }

    //CastingMachine
    function hasCastingRole(address _account) public view returns (bool) {
        require(_account != address(0));
        return roles[_account].Casting;
    }

    function addCastingRole(address _account) public {
        require((_account != address(0))&&(msg.sender==owner));
        require(!hasCastingRole(_account));

        roles[_account].Casting = true;
    }

    modifier manufactured(uint256 _uid) {
        require(ladles[_uid].ladleState == Structure.State.Manufactured);
        _;}
     modifier shippedByTLC(uint256 _uid) 
    {
        if(!forward)
        {
            require(ladles[_uid].ladleState == Structure.State.ReceivedBy_LF_1,"Not received by lf-1");
        }
        else
        {
        require(ladles[_uid].ladleState == Structure.State.ShippedByTLC,"Not shipped by tlc");
        }
        _;
    }

    modifier receivedByConverter(uint256 _uid) 
    {
        if(forward!=true)
        {
        require(ladles[_uid].ladleState == Structure.State.ReceivedBy_LF_2,"Not received by lf2");
        }
        else
        {
        require(ladles[_uid].ladleState == Structure.State.ReceivedByConverter,"Not received by converter");
        }
        _;
    }

    modifier shippedByConverter(uint256 _uid) 
    {
        if(!forward)
        {
        require(ladles[_uid].ladleState == Structure.State.ShippedBy_LF_2,"Not shipped by Lf-2");
        }
        else{
        require(ladles[_uid].ladleState == Structure.State.ShippedByConverter,"Not shipped by Converter");
        }
        _;
    }

    modifier receivedByLF_1(uint256 _uid) 
    {
        if(!forward)
        {
            require(ladles[_uid].ladleState == Structure.State.ShippedBy_RH
            ,"Not shipped by rh");

        }
        else
        {
            require(
            ladles[_uid].ladleState == Structure.State.ReceivedBy_LF_1
        ,"Not received by lf1");
        }
        _;
    }

    modifier shippedByLF_1(uint256 _uid) 
    {
        if(forward!=true)
        {
            require(ladles[_uid].ladleState == Structure.State.ShippedBy_RH
            ,"Not shipped by rh");
        }
        
        else
        {
        require(
            ladles[_uid].ladleState == Structure.State.ShippedBy_LF_1
        ,"Not shipped by lf1");
        }
        _;
    }

    modifier receivedByLF_2(uint256 _uid) 
    {
        if(!forward)
        {
        require(ladles[_uid].ladleState == Structure.State.ReceivedBy_CastingMachine
        ,"Not received by casting machine");
        }
        else
        {
        require(
            ladles[_uid].ladleState == Structure.State.ReceivedBy_LF_2
        ,"Not received by lf2");
        }
        _;
    }

    modifier shippedByLF_2(uint256 _uid) 
    {
        if(!forward)
        {
            require(ladles[_uid].ladleState == Structure.State.ShippedBy_RH,"Not shipped by rh");
        }
        else{
        require(
            ladles[_uid].ladleState == Structure.State.ShippedBy_LF_2,"Not shipped by lf2");
       }
        _;
    }

    modifier receivedByRH(uint256 _uid) {
        require(
            ladles[_uid].ladleState == Structure.State.ReceivedBy_RH
        ,"received by rh");
        _;
    }

    modifier shippedByRH(uint256 _uid) {
        require(
            ladles[_uid].ladleState == Structure.State.ShippedBy_RH
        ,"received by rh");
        _;
    }

    modifier receivedByCasting(uint256 _uid) {
        require(
            ladles[_uid].ladleState == Structure.State.ReceivedBy_CastingMachine
        ,"received by casting");
        _;
    }

}   