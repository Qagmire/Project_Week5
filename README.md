# Token Wallet — bài thực hành ERC20/ERC721
React dùng Vite, Web3; giữ Solidity 0.5.2, OpenZeppelin 2.2.0 và cấu trúc src/Components, src/Token, src/Contracts.

## Chạy trên Windows
1. npm.cmd install
2. Terminal 1: npm.cmd run ganache (hoặc Ganache GUI, RPC 127.0.0.1:8545, chain ID 1337).
3. Terminal 2: npm.cmd run deploy (deploy và đồng bộ ABI/địa chỉ).
4. Terminal 2: npm.cmd run dev. Mở http://127.0.0.1:5173.
5. MetaMask: thêm RPC http://127.0.0.1:8545, Chain ID 1337, ký hiệu ETH. Import tài khoản test đầu tiên của Ganache (minter MC) và tài khoản thứ hai. Chỉ nhập khóa test vào MetaMask.
6. Kết nối ví; mint 100 MC cho tài khoản 1; chuyển 10 MC cho tài khoản 2.
7. Mint NFT cho tài khoản 1, metadata: Apartment A - Ho Chi Minh City - 80m2. Kiểm tra ID/owner/metadata; chuyển NFT cho tài khoản 2.
8. Đổi tài khoản MetaMask và kết nối lại để kiểm tra token nhận được.
9. Approve MC cho tài khoản 2; tài khoản 2 dùng Chuyển MC được ủy quyền. Approve NFT cũng cho phép tài khoản 2 chuyển ID được duyệt.
10. Nếu reset Ganache: truffle.cmd migrate --reset --network development; npm.cmd run sync-contracts; tải lại trang.
npm.cmd test dùng blockchain riêng. npm.cmd run build kiểm tra frontend.

## Trả lời câu hỏi
- ERC20 có thể thay thế tương đương; ERC721 có ID riêng và metadata.
- Name: Moolah Coin; symbol: MC; decimals: 4.
- Cap: 10.000.000.000 đơn vị nhỏ nhất = 1.000.000 MC; tổng cung ban đầu 0.
- ABI mô tả hàm/sự kiện/kiểu dữ liệu để Web3 mã hóa lời gọi và giải mã kết quả. Bytecode là mã EVM triển khai.
- balanceOf(account).call() chỉ đọc, không thay đổi trạng thái.
- createNFT tăng Id, mint cho receiver, gắn metadata và ghi MDTrack.
- MDTrack chỉ là một ID đại diện; giao diện đọc ownerOf để hiển thị đầy đủ NFT.
- Workflow: nhấn Mint → Web3 → MetaMask xác nhận/ký → Ganache thực thi → receipt → React đọc lại dữ liệu.
- MinterRole kiểm soát mint MC; riêng biệt với Ownable.

## Chỉnh sửa Condos
Đã kiểm tra _isApprovedOrOwner, cập nhật đúng ID chuyển và giữ ID đại diện cho NFT còn lại. Áp dụng cả transferFrom/safeTransferFrom. Giữ API, metadata theo đề. Quét ID chỉ phù hợp bài lab nhỏ.

## Minh chứng nộp bài
Chụp thực tế: (1) Ganache chạy, Account 1/2 và balance; (2–3) hai file Solidity; (4) compile; (5) deploy; (6–7) địa chỉ MC/CONDO; (8) MetaMask nối local; (9) balance MC; (10) NFT/owner/metadata; (11) mint NFT thành công; (12) transfer thành công và balance/owner người nhận.
Địa chỉ tại build/contracts/*.json hoặc src/Contracts/*.json, mục networks; cũng hiển thị trên giao diện. Hash/block giao dịch lưu trong phiên, chụp trước khi tải lại trang.
Bạn tự import tài khoản, ký MetaMask và chụp ảnh trình duyệt; không ghi private key vào báo cáo.

## Local session
Ganache background logs: .ganache/server.log (test account keys for MetaMask). Do not submit this log. Stop process PID 15160 before starting another Ganache on port 8545.
Run npm.cmd run demo to mint 100 MC, transfer 10 MC, mint and transfer an NFT. Each run creates another NFT. Public receipts and balances are saved in lab-evidence.json. This uses unlocked Ganache accounts; MetaMask signing must still be demonstrated separately.

## MetaMask và đối chiếu đề bài
Xem REQUIREMENTS.md để kết nối MetaMask thật, kiểm tra từng yêu cầu và chụp 12 minh chứng. Ganache mới lưu tài khoản/dữ liệu tại .ganache; nhấp đúp run-wallet.bat để chạy lại.
