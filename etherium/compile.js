const path = require('path');
const fs = require('fs-extra');
const solc = require('solc');

const buildPath = path.resolve(__dirname, 'build');
fs.removeSync(buildPath);

const campaignContractPath = path.resolve(__dirname, 'contracts', 'Campaign.sol');
const sourceCode = fs.readFileSync(campaignContractPath,'utf8');

const output = solc.compile(sourceCode, 1).contracts;

fs.ensureDirSync(buildPath);
for(let contract in output){
    fs.outputJsonSync(
        path.resolve(buildPath, contract.replace(':','') + '.json'),
        output[contract]
    );
}