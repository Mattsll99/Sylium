const { SignerWithAddress } = require("@nomiclabs/hardhat-ethers/signers");
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("SYLI", async function () {
  /* ========== INSTANCES OF THE ADDRESSES ========== */
  let syli;

  beforeEach(async () => {
    const SYLI = await ethers.getContractFactory("SYLI");
    syli = await SYLI.deploy();
    await syli.deployed();
    //await syli.approve(receiver.address, 100);
  });
  it("Should execute the minting and the burning of Sylium", async function () {
    const [governance, receiver] = await ethers.getSigners();

    console.log("========== MINTING SYLIUM ==========");
    await syli.mint_syli(receiver.address, 100);
    let receiverBalance = await syli.balanceOf(receiver.address);
    console.log(receiverBalance);

    console.log(
      "========== BURNING SYLIUM FROM THE RECEIVER ADDRESS =========="
    );
    await syli.connect(receiver).approve(governance.address, 70);
    await syli.burn_syli(receiver.address, 20);
    let updatedBalance = await syli.balanceOf(receiver.address);
    console.log(updatedBalance);
  });
});

// https://hardhat.org/guides/waffle-testing.html
