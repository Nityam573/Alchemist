// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "./Structure.sol";
//import "./Modifiers.sol";

library Structure {
    enum State {
        Manufactured,//0
        ShippedByTLC,//1
        ReceivedByConverter,//2
        ShippedByConverter,//3
        ReceivedBy_Slagpot,//4
        ReceivedBy_LF_1,//5
        ShippedBy_LF_1,//6
        ShippedBy_Slagpot,//7
        ReceivedBy_LF_2,//8
        ReceivedBy_Slag_dumping,//9
        ShippedBy_LF_2,//10
        ReceivedBy_RH,//11
        ShippedBy_RH,//12
        ReceivedBy_CastingMachine,//13
        ShippedBy_CastingMachine//14
    }
    struct TLCDetails {
        address manufacturer;
        uint256 manufacturedDate;
    }
    struct LadleDetails {
        uint256 ladleNumber;
    }
    struct ConverterDetails {
        address converter;
        uint shipConverterDate;
        uint recConverterDate;
    }
    struct LF_1_Details {
        address lf_1;
        uint shipLf_1Date;
        uint recLf_1Date;
    }
    struct LF_2_Details {
        address lf_2;
        uint shipLf_2Date;
        uint recLf_2Date;
    }
    struct RH_Details {
        address rh;
        uint shipRhDate;
        uint recRhDate;
    }
    struct Casting_Details {
        address castingM;
        uint shipCastingDate;
        uint recCastingDate;
    }
    struct Slagpot_Details {
        address slagpot;
       uint shipSlagDate;
        uint recSlagDate;
    }
    struct Slagpot_dumping_Details {
        address slagpot_dumping;
    }
    struct Ladle {
        uint256 uid;
        address owner;
        State ladleState;
        TLCDetails manufacturer;
        ConverterDetails conv;
        LadleDetails ladledet;
        LF_1_Details lf1;
        LF_2_Details lf2;
        RH_Details rh;
        Casting_Details castingM;
        string transaction;
    }

    struct LadleHistory {
        Ladle[] history;
    }

    struct Roles {
        bool TLC;
        bool Converter;
        bool LF_1;
        bool LF_2;
        bool RH;
        bool Casting;
        bool SlagPot;
        bool Dumping;
    }
 // Block number stuct
    struct Txblocks {
        uint256 TTC; // blockTLCToConverter
        uint256 CTLF_1; // blockConverterToLf-1
        uint256 LF_1TLF_2; // blockLF-1ToLf-2
        uint256 LF_2TRH; //blockLf-2toRh
        
        
    }
}

contract Tracking 
{
    event ManufacturerAdded(address indexed _account);
    uint256 public uid;
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
     
        require(ladles[_uid].ladleState == Structure.State.ShippedByTLC,"Nst");
        _;
    }

    modifier receivedByConverter(uint256 _uid) 
    {
        if(!forward)
        {
        require(ladles[_uid].ladleState == Structure.State.ReceivedBy_LF_2,"Nr2");
        }       
        else
        {
        require(ladles[_uid].ladleState == Structure.State.ReceivedByConverter,"Nrc");
        }
        _;
    }

    modifier shippedByConverter(uint256 _uid) 
    {
        if(!forward)
        {
        require(ladles[_uid].ladleState == Structure.State.ShippedBy_LF_2,"Ns2");
        }
        else{
        require(ladles[_uid].ladleState == Structure.State.ShippedByConverter,"NsC");
        }
        _;
    }

    modifier receivedByLF_1(uint256 _uid) 
    {
        if(!forward)
        {
            require(ladles[_uid].ladleState == Structure.State.ReceivedBy_RH
            ,"Nrr");

        }
        else
        {
            require(
            ladles[_uid].ladleState == Structure.State.ReceivedBy_LF_1
        ,"Nr1");
        }
        _;
    }

    modifier shippedByLF_1(uint256 _uid) 
    {
        if(!forward)
        {
            require(ladles[_uid].ladleState == Structure.State.ShippedBy_RH
            ,"Nsr");
        }
        
        else
        {
        require(
            ladles[_uid].ladleState == Structure.State.ShippedBy_LF_1
        ,"Ns1");
        }
        _;
    }

    modifier receivedByLF_2(uint256 _uid) 
    {
        if(!forward)
        {
        require(ladles[_uid].ladleState == Structure.State.ReceivedBy_CastingMachine
        ,"Nrm");
        }
        else
        {
        require(
            ladles[_uid].ladleState == Structure.State.ReceivedBy_LF_2
        ,"Nr2");
        }
        _;
    }

    modifier shippedByLF_2(uint256 _uid) 
    {
        if(!forward)
        {
            require(ladles[_uid].ladleState == Structure.State.ShippedBy_CastingMachine,"Nsm");
        }
        else{
        require(
            ladles[_uid].ladleState == Structure.State.ShippedBy_LF_2,"Ns2");
       }
        _;
    }

    modifier receivedByRH(uint256 _uid) {
        require(
            ladles[_uid].ladleState == Structure.State.ReceivedBy_RH
        ,"rr");
        _;
    }

    modifier shippedByRH(uint256 _uid) {
        require(
            ladles[_uid].ladleState == Structure.State.ShippedBy_RH
        ,"sr");
        _;
    }

    modifier receivedByCasting(uint256 _uid) {
        require(
            ladles[_uid].ladleState == Structure.State.ReceivedBy_CastingMachine
        ,"rm");
        _;
    }

    mapping(uint256 => Structure.LadleHistory) ladleHistory; 
    //TLC    
    constructor()  payable {
        owner = msg.sender;
        uid = 0;
    }
    mapping(string=>uint[10])  lntCnt ; uint i;
   // mapping(address=>uint[]) uidCnt;
   
   
    event Manufactured(uint256 uid);
    event ShippedByTLC(uint256 uid);
    event ReceivedByConverter(uint256 uid);
    event ShippedByConverter(uint256 uid);
    event ReceivedByLF_1(uint256 uid);
    event ShippedByLF_1(uint256 uid);
    event ReceivedByLF_2(uint256 uid);
    event ShippedByLF_2(uint256 uid);
    event ReceivedByRH(uint256 uid);
    event ShippedByRH(uint256 uid);
    event ReceivedByCasting(uint256 uid);
    event ShippedByCasting(uint256 uid);
    function manufactureEmptyInitialize(Structure.Ladle memory ladle) internal pure {
        address converter;
        string memory transaction;
        address lf_1;
        address lf_2;
        address rh;
        address castingMachine;
        ladle.conv.converter = converter;
        ladle.lf1.lf_1 = lf_1;
        ladle.lf2.lf_2 = lf_2;
        ladle.rh.rh = rh;
        ladle.castingM.castingM = castingMachine;
        ladle.transaction = transaction;        
    }
    function manufactureLadleInitialize(
        Structure.Ladle memory ladle,
        uint256 ladleCode
    ) internal pure {
        ladle.ladledet.ladleNumber = ladleCode;
    }

    // STEP 1 : Ladle Formation
    function manufactureLadle(uint256 productCode)public {
        require(hasTLCRole(msg.sender));
        uid = uid + 1;
        uint256 _uid = uid;
        Structure.Ladle memory ladle;
        ladle.uid = _uid;
        ladle.manufacturer.manufacturedDate = block.timestamp;
        ladle.owner = msg.sender;
        ladle.manufacturer.manufacturer = msg.sender;
        manufactureEmptyInitialize(ladle);
        ladle.ladleState = Structure.State.Manufactured;
        manufactureLadleInitialize(ladle,productCode);
        ladles[_uid] = ladle;
        ladleHistory[_uid].history.push(ladle);
        emit Manufactured(_uid);}
    //Converter.
    function shipToConverter(uint256 _uid)public{
        if(!forward){
            require(hasLF_1Role(msg.sender));
            require(ladles[_uid].ladleState == Structure.State.ReceivedBy_LF_1);
        }
        else{
        require(hasTLCRole(msg.sender));}
        ladles[_uid].ladleState = Structure.State.ShippedByTLC;
        ladles[_uid].conv.shipConverterDate=block.timestamp;
        ladleHistory[_uid].history.push(ladles[_uid]);
        lntCnt["converter"][i]=_uid;i++;
        emit ShippedByTLC(_uid);
    }
    function receiveByConverter(uint256 _uid)public shippedByTLC(_uid)   {
        require(hasConverterRole(msg.sender));
        // ladles[_uid].owner = msg.sender;
        ladles[_uid].ladleState = Structure.State.ReceivedByConverter;
        ladles[_uid].conv.recConverterDate=block.timestamp;
        ladleHistory[_uid].history.push(ladles[_uid]);
        i--;
        lntCnt["converter"][i]=0;
        if(!forward){forward=true;}
        emit ReceivedByConverter(_uid);
    }
    // LF-1.
    function shipToLF_1(uint256 _uid) public receivedByConverter(_uid){
        if(!forward){
            require(hasLF_2Role(msg.sender));
            ladles[_uid].ladleState = Structure.State.ShippedBy_LF_2;
            forward=false;}
        else{
            require(hasConverterRole(msg.sender));
        ladles[_uid].ladleState = Structure.State.ShippedByConverter;}
        ladleHistory[_uid].history.push(ladles[_uid]);   
        ladles[_uid].lf1.shipLf_1Date=block.timestamp;     
       lntCnt["lf-1"][i]=_uid;i++;
        emit ShippedByConverter(_uid);}
    function receiveByLF_1(uint256 _uid)
        public
        shippedByConverter(_uid){
        require(hasLF_1Role(msg.sender));
        ladles[_uid].owner = msg.sender;
        ladles[_uid].ladleState = Structure.State.ReceivedBy_LF_1;
        ladles[_uid].lf1.recLf_1Date=block.timestamp;     
        ladleHistory[_uid].history.push(ladles[_uid]);i--;
        lntCnt["lf-1"][i]=0;
        emit ReceivedByLF_1(_uid);
    }
    // LF-2.
    function shipToLF_2(uint256 _uid)
        public
        receivedByLF_1(_uid){
        if(forward){
            require(hasLF_1Role(msg.sender));
        ladles[_uid].ladleState = Structure.State.ShippedBy_LF_1;
         ladles[_uid].lf2.shipLf_2Date=block.timestamp;     
        ladleHistory[_uid].history.push(ladles[_uid]);
        lntCnt["lf-2"][i]=_uid;i++;
        emit ShippedByLF_1(_uid);}
        else{
            require(hasRHRole(msg.sender));
        ladles[_uid].ladleState = Structure.State.ShippedBy_RH;
        ladles[_uid].lf2.shipLf_2Date=block.timestamp;     
        ladleHistory[_uid].history.push(ladles[_uid]);
        forward=false;
       lntCnt["lf-2"][i]=_uid;i++;
        emit ShippedByRH(_uid);
        }
        }
    function receiveByLF_2(uint256 _uid) public shippedByLF_1(_uid)
    { require(hasLF_2Role(msg.sender));
        ladles[_uid].owner = msg.sender;
        ladles[_uid].ladleState = Structure.State.ReceivedBy_LF_2;
        ladles[_uid].lf2.recLf_2Date=block.timestamp;     
        ladleHistory[_uid].history.push(ladles[_uid]);i--;
      lntCnt["lf-2"][i]=0;
        emit ReceivedByLF_2(_uid);
    }
    // RH
    function shipToRH(uint256 _uid) public receivedByLF_2(_uid){
        if(forward!=true){
            require(hasCastingRole(msg.sender));
    ladles[_uid].ladleState = Structure.State.ShippedBy_CastingMachine;
    ladles[_uid].rh.shipRhDate=block.timestamp;     
    ladleHistory[_uid].history.push(ladles[_uid]);
  lntCnt["rh"][i]=_uid; i++;
    emit ShippedByCasting(_uid);
        }
        else{
             require(hasLF_2Role(msg.sender));
        ladles[_uid].ladleState = Structure.State.ShippedBy_LF_2;
        ladles[_uid].rh.shipRhDate=block.timestamp;     
        ladleHistory[_uid].history.push(ladles[_uid]);
   lntCnt["rh"][i]=_uid;i++;
        emit ShippedByLF_2(_uid);}
        
    }
    function receiveByRH(uint256 _uid) public shippedByLF_2(_uid){
        require(hasRHRole(msg.sender));
        ladles[_uid].owner = msg.sender;
        ladles[_uid].ladleState = Structure.State.ReceivedBy_RH;
        ladles[_uid].rh.recRhDate=block.timestamp;     
        ladleHistory[_uid].history.push(ladles[_uid]);i--;
     lntCnt["rh"][i]=0;
        emit ReceivedByRH(_uid);
    }

    function shipByRH(uint256 _uid)
        public
        receivedByRH(_uid)
    {
        require(hasRHRole(msg.sender));
        ladles[_uid].ladleState = Structure.State.ShippedBy_RH;
        ladles[_uid].castingM.shipCastingDate=block.timestamp;     
        //shipCastingDate
      lntCnt["casting"][i]=_uid;i++;
        ladleHistory[_uid].history.push(ladles[_uid]);
        emit ShippedByRH(_uid);
    }
    //Casting
    function receiveByCastingMachine(uint256 _uid)
        public
        shippedByRH(_uid)
    {
        require(hasCastingRole(msg.sender));
        ladles[_uid].owner = msg.sender;
        ladles[_uid].ladleState = Structure.State.ReceivedBy_CastingMachine;
        ladles[_uid].castingM.recCastingDate=block.timestamp;     
        ladleHistory[_uid].history.push(ladles[_uid]);
        forward=false;i--;
        lntCnt["casting"][i]=0;
        emit ReceivedByCasting(_uid);
       
    }
    // function fetchLadleCountAtStation(address accnt,uint stage) public view returns (uint256) {
    //     return lntCnt[accnt][stage];}

    function fetchLadleHistory(uint256 _uid)
        public
        view
        returns (Structure.Ladle[] memory,Structure.State){
        return (ladleHistory[_uid].history,ladles[_uid].ladleState);}

    function fetchCLnt(string memory _add)
        public
        view
        returns (uint,uint[10] memory){ uint cnt;
            for(uint j=0;j<10;j++){
                if(lntCnt[_add][j]>=1){
                    cnt++;
                }
            }
        return (cnt,lntCnt[_add]);}

    function LastTime(uint _uid) public view  returns (uint256){
        if(ladles[_uid].ladleState== Structure.State.ShippedByTLC ){
            if(forward){
                return ladles[_uid].manufacturer.manufacturedDate;
            }
        }
        else if(ladles[_uid].ladleState== Structure.State.ReceivedByConverter){
            if(forward){
                return ladles[_uid].manufacturer.manufacturedDate;
            }
            else{
                return ladles[_uid].lf1.shipLf_1Date;
            }
        }
        else if(ladles[_uid].ladleState== Structure.State.ShippedByConverter){
            if(forward){
                return ladles[_uid].conv.recConverterDate;
            }
            else{
                return ladles[_uid].conv.recConverterDate;
            }
        }
        else if(ladles[_uid].ladleState== Structure.State.ReceivedBy_LF_1){
            if(forward){
                return ladles[_uid].conv.shipConverterDate;
            }
            else{
                return ladles[_uid].lf2.shipLf_2Date;
            }
        }
        else if(ladles[_uid].ladleState== Structure.State.ShippedBy_LF_1){
            if(forward){
                return ladles[_uid].lf1.recLf_1Date;
            }
            else{
                return ladles[_uid].lf1.recLf_1Date;
            }
        }
        else if(ladles[_uid].ladleState== Structure.State.ReceivedBy_LF_2){
            if(forward){
                return ladles[_uid].lf1.shipLf_1Date;
            }
            else{
                return ladles[_uid].rh.shipRhDate;
            }
        }
        else if(ladles[_uid].ladleState== Structure.State.ShippedBy_LF_2){
            if(forward){
                return ladles[_uid].lf2.recLf_2Date;
            }
            else{
                return ladles[_uid].lf2.recLf_2Date;
            }
        }
        else if(ladles[_uid].ladleState== Structure.State.ReceivedBy_RH){
            if(forward){
                return ladles[_uid].lf2.shipLf_2Date;
            }
            else{
                return ladles[_uid].castingM.shipCastingDate;
            }
        }
        else if(ladles[_uid].ladleState== Structure.State.ShippedBy_RH){
            if(forward){
                return ladles[_uid].rh.recRhDate;
            }
            else{
                return ladles[_uid].rh.recRhDate;
            }
        }
        else if(ladles[_uid].ladleState== Structure.State.ReceivedBy_CastingMachine){
            if(forward){
                return ladles[_uid].rh.shipRhDate;
            }
        }
        else if(ladles[_uid].ladleState== Structure.State.ShippedBy_CastingMachine){
            if(forward){
                return ladles[_uid].castingM.recCastingDate;
            }
            else{
                return ladles[_uid].castingM.recCastingDate;
            }
        }
        return 0;
    }
}   