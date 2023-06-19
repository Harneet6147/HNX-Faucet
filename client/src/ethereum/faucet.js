import abi from "../faucet_abi.json";
import { ethers } from "ethers";

const faucetContract = (provider) => {

    return new ethers.Contract(
        "0x1302D8F1579956BD24Ae0d0dA6446Bd44E603D89",
        abi,
        provider
    );
}

export default faucetContract;