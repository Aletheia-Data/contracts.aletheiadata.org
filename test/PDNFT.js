const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("PDNFT", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployOneYearPDNFTFixture() {
    const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
    const ONE_GWEI = 1_000_000_000;

    const PDNFTedAmount = ONE_GWEI;
    const unPDNFTTime = (await time.latest()) + ONE_YEAR_IN_SECS;

    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const PDNFTContract = await ethers.getContractFactory("PDNft");
    const PDNFT = await PDNFTContract.deploy();

    return { PDNFT, unPDNFTTime, PDNFTedAmount, owner, otherAccount };
  }

  describe("Deployment", function () {
    it("Should set the right unPDNFTTime", async function () {
      const { PDNFT, unPDNFTTime } = await loadFixture(deployOneYearPDNFTFixture);

      expect(await PDNFT.unPDNFTTime()).to.equal(unPDNFTTime);
    });

    it("Should set the right owner", async function () {
      const { PDNFT, owner } = await loadFixture(deployOneYearPDNFTFixture);

      expect(await PDNFT.owner()).to.equal(owner.address);
    });

    it("Should receive and store the funds to PDNFT", async function () {
      const { PDNFT, PDNFTedAmount } = await loadFixture(
        deployOneYearPDNFTFixture
      );

      expect(await ethers.provider.getBalance(PDNFT.address)).to.equal(
        PDNFTedAmount
      );
    });

    it("Should fail if the unPDNFTTime is not in the future", async function () {
      // We don't use the fixture here because we want a different deployment
      const latestTime = await time.latest();
      const PDNFT = await ethers.getContractFactory("PDNFT");
      await expect(PDNFT.deploy(latestTime, { value: 1 })).to.be.revertedWith(
        "UnPDNFT time should be in the future"
      );
    });
  });

  describe("Withdrawals", function () {
    describe("Validations", function () {
      it("Should revert with the right error if called too soon", async function () {
        const { PDNFT } = await loadFixture(deployOneYearPDNFTFixture);

        await expect(PDNFT.withdraw()).to.be.revertedWith(
          "You can't withdraw yet"
        );
      });

      it("Should revert with the right error if called from another account", async function () {
        const { PDNFT, unPDNFTTime, otherAccount } = await loadFixture(
          deployOneYearPDNFTFixture
        );

        // We can increase the time in Hardhat Network
        await time.increaseTo(unPDNFTTime);

        // We use PDNFT.connect() to send a transaction from another account
        await expect(PDNFT.connect(otherAccount).withdraw()).to.be.revertedWith(
          "You aren't the owner"
        );
      });

      it("Shouldn't fail if the unPDNFTTime has arrived and the owner calls it", async function () {
        const { PDNFT, unPDNFTTime } = await loadFixture(
          deployOneYearPDNFTFixture
        );

        // Transactions are sent using the first signer by default
        await time.increaseTo(unPDNFTTime);

        await expect(PDNFT.withdraw()).not.to.be.reverted;
      });
    });

    describe("Events", function () {
      it("Should emit an event on withdrawals", async function () {
        const { PDNFT, unPDNFTTime, PDNFTedAmount } = await loadFixture(
          deployOneYearPDNFTFixture
        );

        await time.increaseTo(unPDNFTTime);

        await expect(PDNFT.withdraw())
          .to.emit(PDNFT, "Withdrawal")
          .withArgs(PDNFTedAmount, anyValue); // We accept any value as `when` arg
      });
    });

    describe("Transfers", function () {
      it("Should transfer the funds to the owner", async function () {
        const { PDNFT, unPDNFTTime, PDNFTedAmount, owner } = await loadFixture(
          deployOneYearPDNFTFixture
        );

        await time.increaseTo(unPDNFTTime);

        await expect(PDNFT.withdraw()).to.changeEtherBalances(
          [owner, PDNFT],
          [PDNFTedAmount, -PDNFTedAmount]
        );
      });
    });
  });
});
