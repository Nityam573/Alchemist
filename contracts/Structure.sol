// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

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