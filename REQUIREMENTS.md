# Đối chiếu đề bài và cách kiểm tra

## Kết nối MetaMask thật
1. Nhấp đúp run-wallet.bat. Ganache và React chạy local; file .bat deploy và đồng bộ địa chỉ contract.
2. Mở http://127.0.0.1:5173 bằng trình duyệt có MetaMask. Không mở index.html bằng file://.
3. Import tài khoản test Ganache vào MetaMask. Khi khởi động Ganache bằng script mới, khóa test nằm trong .ganache/accounts.txt. Phiên Ganache cũ đang chạy có khóa test trong .ganache/server.log. Không nộp các tệp này.
4. Nhấn Kết nối MetaMask. Đồng ý cấp quyền và thêm/chuyển mạng Ganache Local nếu MetaMask hỏi. RPC http://127.0.0.1:8545, Chain ID 1337; Network ID 5777.
5. Dùng tài khoản deploy để mint MC; tài khoản khác vẫn mint NFT được theo ví dụ trong đề.
6. Nhấn Thêm MC vào MetaMask để đăng ký MC trong extension.
7. Mint MC cho tài khoản 1, chuyển MC sang tài khoản 2. Mỗi thao tác phải có yêu cầu ký MetaMask; xác nhận rồi kiểm tra balance.
8. Mint NFT với metadata "Apartment A - Ho Chi Minh City - 80m2"; kiểm tra Token ID, owner và metadata.
9. Chuyển NFT sang tài khoản 2. Đổi tài khoản MetaMask: ví tự cập nhật.
10. Approve MC/NFT từ tài khoản 1 cho tài khoản 2; tài khoản 2 thực hiện transferFrom MC hoặc chuyển NFT được duyệt.
11. Chụp lịch sử giao dịch có hash/block, số dư MC và NFT người nhận. Lịch sử lưu localStorage của trình duyệt.

## 12 minh chứng trong đề
| # | Yêu cầu | Vị trí / cách xác minh |
|---|---|---|
| 1 | Ganache đang chạy | Cửa sổ Ganache; ghi Account 1/2 và balance |
| 2 | Source ERC20 | contracts/MoolahCoin.sol |
| 3 | Source ERC721 | contracts/Condos.sol |
| 4 | Compile thành công | npm.cmd run compile; compiler solc 0.5.2 |
| 5 | Deploy hai contract | npm.cmd run deploy hoặc run-wallet.bat |
| 6 | Địa chỉ ERC20 | src/Contracts/MoolahCoin.json → networks; mục Ví đang kết nối |
| 7 | Địa chỉ ERC721 | src/Contracts/Condos.json → networks; mục Ví đang kết nối |
| 8 | MetaMask nối local | Chụp MetaMask: Ganache Local, Chain ID 1337 |
| 9 | Wallet hiển thị ERC20 | Thẻ Moolah Coin, balance đúng 4 decimals |
| 10 | Wallet hiển thị NFT | Thẻ Condos: ID, owner, metadata |
| 11 | Mint NFT thành công | Xác nhận MetaMask; chụp NFT và hash/block |
| 12 | Transfer thành công | Chụp hash/block và balance/owner người nhận |

## Các phần kỹ thuật của đề
- Solidity 0.5.2, OpenZeppelin 2.2.0; Moolah Coin / MC / 4 decimals; cap 10.000.000.000 đơn vị nhỏ nhất = 1.000.000 MC.
- Truffle migrations triển khai MoolahCoin và Condos trên Ganache cổng 8545.
- React, Web3 và cấu trúc src/Components, src/Token/all20.js, all721.js, MoolahCoin.js, Condos.js, src/Contracts.
- React được chạy bằng Vite thay cho lệnh create-react-app legacy trong đề; không thay đổi chức năng ví cần nộp.
- balanceOf(account).call() chỉ đọc; ABI mã hóa hàm/sự kiện và giải mã dữ liệu; bytecode là mã EVM được triển khai.
- MDTrack(account).call() đọc ID đại diện; tokenURI đọc metadata. Giao diện còn đọc ownerOf để hiển thị tất cả NFT.
- createNFT tăng Id, _mint, _setTokenURI và ghi MDTrack. transferNFT kiểm tra quyền owner/approved trước khi chuyển.
- Workflow: User → React → Web3 → MetaMask xác nhận/ký → Ganache → contract thực thi → receipt → UI cập nhật.
- MinterRole kiểm soát mint MC, độc lập với Ownable.

## Kiểm chứng
- npm.cmd test: kiểm thử contract trên Ganache riêng.
- npm.cmd run build: biên dịch frontend.
- npm.cmd run test:browser: chạy Edge headless với provider EIP-1193/EIP-6963 mô phỏng và EVM Ganache thật, riêng biệt. Không phải kiểm thử cửa sổ extension MetaMask thật.
- test-results/browser-check.json ghi kết quả tự động.
- Các screenshot MetaMask/Ganache và ký giao dịch trên extension thật cần thực hiện theo các bước trên. Không dùng kết quả provider mô phỏng làm ảnh minh chứng MetaMask thật.

## Tài khoản và khởi động lại
scripts/start-ganache.js lưu cấu hình ví test ở .ganache/wallet.json và blockchain ở .ganache/db; khóa test xuất ra .ganache/accounts.txt. Thư mục .ganache bị loại khỏi Git.
Giữ dữ liệu này để tái sử dụng cùng tài khoản MetaMask. Không chạy hai Ganache trên cổng 8545.
Nếu tự reset blockchain, cần deploy lại, import đúng tài khoản và kiểm tra nonce/giao dịch chờ trong MetaMask.

Tham khảo provider discovery: https://eips.ethereum.org/EIPS/eip-6963
