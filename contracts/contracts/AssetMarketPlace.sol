// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "./AssetNFT.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AssetMarketPlace {

    address public immutable owner;
    string public name = "CropSwap";
    AssetNFT public nft;
    ERC20 public coin;
    mapping(uint128 => AssetData) public assets;
    struct AssetData {
        address owner;
        uint price;
        bool payedFor;
        bool booked;
        address payer;
        bool payerChecked;
        bool buyerChecked;

    }

    event PaymentWithdrawn(uint128 indexed nftId, address indexed seller, uint256 amount);
    event Listed(uint128 indexed nftId, address indexed lister, uint256 price);
    event PaymentReceived(uint128 indexed nftId, address indexed payer, uint256 price);
    event ItemDelivered(uint128 indexed nftId, address indexed confirmer, bool isPayer);

    // nfts
    uint128[] public assetIds;

    // constructor
    constructor ( address _nft, address _coin){
        owner = msg.sender;
        nft = AssetNFT(_nft);
        coin = ERC20(_coin);
    }

    function list_for_sale(uint128 nftId, uint256 price, address lister) external returns (bool) {
        require(nft.ownerOf(nftId)== lister ,"NOT_OWNED");

        nft.transferFrom(lister, address(this), nftId);
        
        AssetData memory data = AssetData(
            lister,
            price,
            false,
            false,
            address(0),
            false,
            false
        );
        assets[nftId] =data;
        
        // add nft
        assetIds.push(nftId);
        emit Listed(nftId, lister, price);
        return true;
    }

    function get_listings(uint start, uint end) public view returns (uint[] memory) {
        uint[] memory ids = new uint[](end - start);
        
        for (uint i = start ; i < assetIds.length; i++) {
            if(i >= end){
                break;
            }
            ids[i - start] = assetIds[i];
        }
        return ids;

    }


    function payForStock(uint128 nftId) external returns (bool) {
            AssetData storage assetData = assets[nftId];
            require(assetData.price > 0, "INVALID_PRICE");

            // Ensure payer has approved the contract to spend the amount
            require(coin.allowance(msg.sender, address(this)) >= assetData.price, "INSUFFICIENT_ALLOWANCE");

            bool success = coin.transferFrom(msg.sender, address(this), assetData.price);
            require(success, "TRANSFER_FAILED");

            assetData.payedFor = true;
            assetData.payer = msg.sender;

            emit PaymentReceived(nftId, msg.sender, assetData.price);
            return true;
    }


    function mark_as_delivered(uint128 nftId, bool isPayer) external {
        AssetData storage assetData = assets[nftId];
        require(assetData.payedFor, "NOT_PAYED_FOR");
        if (isPayer){
            require(assetData.payer == msg.sender, "NOT_PAYER");
            assetData.payerChecked = true;
            
        }else{
            require(assetData.owner == msg.sender, "NOT_PAYER");
            assetData.buyerChecked = true;
            
        }
        emit ItemDelivered(nftId, msg.sender, isPayer);
    }

    function get_payment(uint128 nftId) external {
        AssetData storage assetData = assets[nftId];
        require(assetData.payedFor, "NOT_PAYED_FOR");
        require(assetData.owner == msg.sender, "NOT_PAYER");
        require(assetData.payerChecked, "NOT_PAYER");
        require(assetData.buyerChecked, "NOT_PAYER");
        uint128 price = uint128((assetData.price * 9) / 10); 

        bool success = coin.transfer(msg.sender, price);
        require(success, "TRANSFER_FAILED");

        emit PaymentWithdrawn(nftId, msg.sender, price);

    }

    function get_user_listing(uint128 limit,address user) public view returns (uint128[] memory){
        uint128[] memory ids = new uint128[](limit);
        uint step = 0;
        for (uint128 i = 0 ; i < assetIds.length; i++) {
            if(i >= limit){
                break;
            }
            AssetData storage assetData = assets[assetIds[i]];
            if( assetData.owner == user){
                ids[step] = assetIds[i];
                step ++;
            }
            
        }
        return ids;

    }

    function get_user_stocks(uint128 limit, address user) public view returns (uint128[] memory){
        uint128[] memory ids = new uint128[](limit);
        uint step = 0;
        for (uint128 i = 0 ; i < assetIds.length; i++) {
            if(i >= limit){
                break;
            }
            AssetData memory assetData = assets[assetIds[i]];
            if( assetData.payer == user){
                ids[step] = assetIds[i];
                step ++;
            }
            
        }
        return ids;

    }

    function get_stock_data(uint128 nftId) public view returns (AssetData memory) {
        AssetData storage assetData = assets[nftId];
        return assetData;
    }
    



    receive() external payable {}
}