const fs = require('fs');
const files = [
    'flatten/Root.sol', 'flatten/Implementation.sol', 'flatten/Deployer.sol',
    'flatten/Exedum.sol', 'flatten/Oracle.sol', 'flatten/Pool.sol'
];

for (const f of files) {
    fs.readFile(f, 'utf8', function (err,data) {
        if (err) {
            return;
        }
        var firstOccuranceIndex = data.search(/pragma experimental ABIEncoderV2;/) + 1;

        var result = data.substr(0, firstOccuranceIndex) + data.slice(firstOccuranceIndex).replace(/pragma experimental ABIEncoderV2;/g, '');

        fs.writeFile(f, result, 'utf8', function (err) {
            if (err) return console.log(err);
        });
    });
}