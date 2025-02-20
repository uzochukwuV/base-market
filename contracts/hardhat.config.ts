import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
const fs = require("fs");
const path = require("path");
const { task } = require("hardhat/config");


const config: HardhatUserConfig = {
  solidity: "0.8.28",
  networks: {
    sepolia: {
      url: `https://sepolia.base.org`,
      accounts: ["ac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"],
    },
  },
};




task("copy-abi", "Copies compiled contract ABIs to frontend")
  .addParam("contract", "Contract name (without .sol extension)")
  .setAction(async ({ contract }, hre) => {
    const sourcePath = `./artifacts/contracts/${contract}.sol/${contract}.json`;
    const destinationPath = `../frontend/src/contracts/${contract}.json`;

    if (!fs.existsSync(sourcePath)) {
      console.error(`Error: ABI for ${contract} not found!`);
      return;
    }

    fs.copyFileSync(sourcePath, destinationPath);
    console.log(`✅ ABI copied to ${destinationPath}`);
  });

export default config;
