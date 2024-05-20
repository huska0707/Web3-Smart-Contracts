const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("Lock", function () {
  async function deployOneYearLockFixture() {
    const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
    const ONE_GWEI = 1_000_000_000;

    const lockedAmount = ONE_GWEI;
    const unlockTime = (await time.latest()) + ONE_YEAR_IN_SECS;
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const Lock = await ethers.getContractFactory("Lock");
    const lock = await Lock.deploy(unlockTime, { value: lockedAmount });
    return { lock, unlockTime, lockedAmount, owner, otherAccount };
  }
});

describe("Deployment", function () {
  it("Should set the right unlockTime", async function () {
    const { lock, unlockTime } = await loadFixture(deployOneYearLockFixture);

    expect(await lock.unlockTime()).to.equal(unlockTime);
  });

  it("Should set the right owner", async function () {
    const { lock, owner } = await loadFixture(deployOneYearLockFixture);

    expect(await lock.owner()).to.equal(owner.address);
  });

  it("Should receive and store the funds to lock", async function () {
    const { lock, lockedAmount } = await loadFixture(deployOneYearLockFixture);

    expect(await ethers.provider.getBalance(lock.address)).to.equal(
      lockedAmount
    );
  });

  it("Should fail if the unlockTime is not in the future", async function () {
    const latestTime = await time.latest();
    const Lock = await ethers.getContractFactory("Lock");
    await expect(Lock.deploy(latestTime, { value: 1 })).to.be.revertedWith(
      "Unlock time should be in the future"
    );
  });
});
