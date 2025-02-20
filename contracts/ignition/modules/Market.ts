import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";


const user = "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266";

const AssetNFT = buildModule("AssetNFT", (m) => {
    
    const nft = m.contract("AssetNFT", [user]);
  
    return { nft };
  });

  const AssetCoin = buildModule("AssetCoin", (m) => {
    
    const coin = m.contract("AssetCoin", [user]);
  
    return { coin };
  });
  
  const AssetMarketPlace = buildModule("AssetMarketPlace", (m) => {
    const { nft } = m.useModule(AssetNFT);
    const { coin } = m.useModule(AssetCoin);
  
    const market = m.contract("AssetMarketPlace", [nft, coin]);
  
  
    return { market };
  });

export default AssetMarketPlace;