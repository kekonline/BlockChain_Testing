const networkConfig = {
    11155111: {   // Sepolia
        name: "sepolia",
        ethUsdPriceFeed: "0x694AA1769357215DE4FAC081bf1f309aDC325306",
    },
    31337: {
        name: "localhost",
        ethUsdPriceFeed: "0x694AA1769357215DE4FAC081bf1f30917f6E7fd5", // Localhost can use the same price feed as Sepolia for testing  
    }
}

const developmentChains = ["hardhat", "localhost"];
const DECIMALS = "8";
const INITIAL_ANSWER = "20000000000"; // 20 USD in 8 decimals

module.exports = {
    networkConfig, developmentChains, DECIMALS, INITIAL_ANSWER
}