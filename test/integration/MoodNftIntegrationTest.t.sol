// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { Test, console } from "forge-std/Test.sol";
import { MoodNft } from "../../src/MoodNft.sol";
import { DeployMoodNft } from "../../script/DeployMoodNft.s.sol";

contract MoodNftIntegrationTest is Test {
    MoodNft public moodNft;
    DeployMoodNft _deployer;
    string public constant HAPPY_SVG_URI = 
        "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgIGhlaWdodD0iNDAwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgogIDxjaXJjbGUgY3g9IjEwMCIgY3k9IjEwMCIgZmlsbD0ieWVsbG93IiByPSI3OCIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIzIi8+CiAgPGcgY2xhc3M9ImV5ZXMiPgogICAgPGNpcmNsZSBjeD0iNjEiIGN5PSI4MiIgcj0iMTIiLz4KICAgIDxjaXJjbGUgY3g9IjEyNyIgY3k9IjgyIiByPSIxMiIvPgogIDwvZz4KICA8cGF0aCBkPSJtMTM2LjgxIDExNi41M2MuNjkgMjYuMTctNjQuMTEgNDItODEuNTItLjczIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IGJsYWNrOyBzdHJva2Utd2lkdGg6IDM7Ii8+Cjwvc3ZnPg==";
    string public constant SAD_SVG_URI =
        "data:application/json;base64,eyJuYW1lIjoiTW9vZCBORlQiLCAiZGVzY3JpcHRpb24iOiJBbiBORlQgdGhhdCByZWZsZWN0cyB0aGUgbW9vZCBvZiB0aGUgb3duZXIsIDEwMCUgb24gQ2hhaW4hIiwgImF0dHJpYnV0ZXMiOiBbeyJ0cmFpdF90eXBlIjogIm1vb2RpbmVzcyIsICJ2YWx1ZSI6IDEwMH1dLCAiaW1hZ2UiOiJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUIzYVdSMGFEMGlNVEF5TkhCNElpQm9aV2xuYUhROUlqRXdNalJ3ZUNJZ2RtbGxkMEp2ZUQwaU1DQXdJREV3TWpRZ01UQXlOQ0lnZUcxc2JuTTlJbWgwZEhBNkx5OTNkM2N1ZHpNdWIzSm5Mekl3TURBdmMzWm5JajRLSUNBOGNHRjBhQ0JtYVd4c1BTSWpNek16SWlCa1BTSk5OVEV5SURZMFF6STJOQzQySURZMElEWTBJREkyTkM0MklEWTBJRFV4TW5NeU1EQXVOaUEwTkRnZ05EUTRJRFEwT0NBME5EZ3RNakF3TGpZZ05EUTRMVFEwT0ZNM05Ua3VOQ0EyTkNBMU1USWdOalI2YlRBZ09ESXdZeTB5TURVdU5DQXdMVE0zTWkweE5qWXVOaTB6TnpJdE16Y3ljekUyTmk0MkxUTTNNaUF6TnpJdE16Y3lJRE0zTWlBeE5qWXVOaUF6TnpJZ016Y3lMVEUyTmk0MklETTNNaTB6TnpJZ016Y3llaUl2UGdvZ0lEeHdZWFJvSUdacGJHdzlJaU5GTmtVMlJUWWlJR1E5SWswMU1USWdNVFF3WXkweU1EVXVOQ0F3TFRNM01pQXhOall1Tmkwek56SWdNemN5Y3pFMk5pNDJJRE0zTWlBek56SWdNemN5SURNM01pMHhOall1TmlBek56SXRNemN5TFRFMk5pNDJMVE0zTWkwek56SXRNemN5ZWsweU9EZ2dOREl4WVRRNExqQXhJRFE0TGpBeElEQWdNQ0F4SURrMklEQWdORGd1TURFZ05EZ3VNREVnTUNBd0lERXRPVFlnTUhwdE16YzJJREkzTW1ndE5EZ3VNV010TkM0eUlEQXROeTQ0TFRNdU1pMDRMakV0Tnk0MFF6WXdOQ0EyTXpZdU1TQTFOakl1TlNBMU9UY2dOVEV5SURVNU4zTXRPVEl1TVNBek9TNHhMVGsxTGpnZ09EZ3VObU10TGpNZ05DNHlMVE11T1NBM0xqUXRPQzR4SURjdU5FZ3pOakJoT0NBNElEQWdNQ0F4TFRndE9DNDBZelF1TkMwNE5DNHpJRGMwTGpVdE1UVXhMallnTVRZd0xURTFNUzQyY3pFMU5TNDJJRFkzTGpNZ01UWXdJREUxTVM0MllUZ2dPQ0F3SURBZ01TMDRJRGd1TkhwdE1qUXRNakkwWVRRNExqQXhJRFE0TGpBeElEQWdNQ0F4SURBdE9UWWdORGd1TURFZ05EZ3VNREVnTUNBd0lERWdNQ0E1Tm5vaUx6NEtJQ0E4Y0dGMGFDQm1hV3hzUFNJak16TXpJaUJrUFNKTk1qZzRJRFF5TVdFME9DQTBPQ0F3SURFZ01DQTVOaUF3SURRNElEUTRJREFnTVNBd0xUazJJREI2YlRJeU5DQXhNVEpqTFRnMUxqVWdNQzB4TlRVdU5pQTJOeTR6TFRFMk1DQXhOVEV1Tm1FNElEZ2dNQ0F3SURBZ09DQTRMalJvTkRndU1XTTBMaklnTUNBM0xqZ3RNeTR5SURndU1TMDNMalFnTXk0M0xUUTVMalVnTkRVdU15MDRPQzQySURrMUxqZ3RPRGd1Tm5NNU1pQXpPUzR4SURrMUxqZ2dPRGd1Tm1NdU15QTBMaklnTXk0NUlEY3VOQ0E0TGpFZ055NDBTRFkyTkdFNElEZ2dNQ0F3SURBZ09DMDRMalJETmpZM0xqWWdOakF3TGpNZ05UazNMalVnTlRNeklEVXhNaUExTXpONmJURXlPQzB4TVRKaE5EZ2dORGdnTUNBeElEQWdPVFlnTUNBME9DQTBPQ0F3SURFZ01DMDVOaUF3ZWlJdlBnbzhMM04yWno0PSJ9";    address _user = makeAddr("user");

    function setUp() public {
        _deployer = new DeployMoodNft();
        moodNft = _deployer.run();
    }

    function testViewTokenUriIntegration() public {
        vm.prank(_user);
        moodNft.mintNft();
        console.log(moodNft.tokenURI(0));
    }

    function testFlipTokenToSad() public {
        vm.startPrank(_user);
        moodNft.mintNft();
        moodNft.flipMood(0);
        vm.stopPrank();
        
        assert(
            keccak256(abi.encodePacked(moodNft.tokenURI(0))) == keccak256(abi.encodePacked(SAD_SVG_URI))
        );
    }
}