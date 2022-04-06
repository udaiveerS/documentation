//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import '@chainlink/contracts/src/v0.8/ChainlinkClient.sol';

/**
 * Request testnet LINK and ETH here: https://faucets.chain.link/
 * Find information on LINK Token Contracts and get the latest ETH and LINK faucets here: https://docs.chain.link/docs/link-token-contracts/
 */

/**
 * THIS IS AN EXAMPLE CONTRACT WHICH USES HARDCODED VALUES FOR CLARITY.
 * PLEASE DO NOT USE THIS CODE IN PRODUCTION.
 */
contract MultiWordConsumer is ChainlinkClient {
    using Chainlink for Chainlink.Request;

    bytes32 private jobId;
    uint256 private fee;

    // multiple params returned in a single oracle response
    uint256 public usd;
    uint256 public eur;
    uint256 public jpy;

    event RequestMultipleFulfilled(bytes32 indexed requestId, uint256 indexed usd, uint256 indexed eur, uint256 jpy);

    /**
     * Network: Kovan
     * Oracle: 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8 (Chainlink Devrel
     * Node)
     * Job ID: 645661528ea44aa7b137ed9f9d54c3d5
     * Fee: 0.1 LINK
     */
    constructor() {
        setPublicChainlinkToken();
        setChainlinkOracle(0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8);
        jobId = '645661528ea44aa7b137ed9f9d54c3d5';
        fee = 0.1 * 10**18; // (Varies by network and job)
    }

    /**
     * @notice Request mutiple parameters from the oracle in a single transaction
     */
    function requestMultipleParameters() public {
        Chainlink.Request memory req = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfillMultipleParameters.selector
        );
        req.addUint('times', 10000);
        sendChainlinkRequest(req, fee);
    }

    /**
     * @notice Fulfillment function for multiple parameters in a single request
     * @dev This is called by the oracle. recordChainlinkFulfillment must be used.
     */
    function fulfillMultipleParameters(
        bytes32 requestId,
        uint256 usdResponse,
        uint256 eurResponse,
        uint256 jpyResponse
    ) public recordChainlinkFulfillment(requestId) {
        emit RequestMultipleFulfilled(requestId, usdResponse, eurResponse, jpyResponse);
        usd = usdResponse;
        eur = eurResponse;
        jpy = jpyResponse;
    }
}
