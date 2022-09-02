pragma solidity >=0.7.0 <0.9.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/PDNft.sol";

contract PDNft {
    function testInitialBalanceUsingDeployedContract() {
        PDNft meta = PDNft(DeployedAddresses.PDNft());

        uint256 expected = 10000;

        Assert.equal(
            meta.getBalance(tx.origin),
            expected,
            "Owner should have 10000 PDNft initially"
        );
    }

    function testInitialBalanceWithNewPDNft() {
        PDNft meta = new PDNft();

        uint256 expected = 10000;

        Assert.equal(
            meta.getBalance(tx.origin),
            expected,
            "Owner should have 10000 PDNft initially"
        );
    }
}
