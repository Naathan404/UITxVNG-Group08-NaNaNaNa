# 🎭 SWAP MASKS

![Godot Engine](https://img.shields.io/badge/Godot_4-%23FFFFFF.svg?style=for-the-badge&logo=godot-engine)
![GDScript](https://img.shields.io/badge/GDScript-%23478CBF.svg?style=for-the-badge&logo=godot-engine&logoColor=white)
![2D Platformer](https://img.shields.io/badge/Genre-2D_Puzzle_Platformer-ff69b4.svg?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-In_Development-success.svg?style=for-the-badge)

## 📖 I. OVERVIEW

### 1.1. Core Concept
**Swap Masks** là một tựa game platformer giải đố nhịp độ cao. Người chơi điều khiển một nhân vật du hành giữa các không gian bằng cách hoán đổi các mặt nạ màu sắc để tương tác với các thực thể trong thế giới tương ứng. Trò chơi là bài kiểm tra gắt gao về khả năng phản xạ, quản lý tài nguyên (oxy) và sự chính xác tuyệt đối trong từng nhịp nhảy.

### 1.2. Player Experience
* **Áp lực sinh tồn:** Thanh oxy liên tục cạn kiệt tạo cảm giác khẩn trương, thúc ép người chơi liên tục di chuyển và tính toán đường đi để tìm kiếm bình cứu sinh.
* **Thao tác nhịp độ cao:** Sự kết hợp giữa việc đổi mặt nạ liên tục giữa không trung và các chướng ngại vật thoắt ẩn thoắt hiện tạo ra trải nghiệm dồn dập, thỏa mãn khi vượt qua.

---

## ⚙️ II. CORE MECHANICS

### 2.1. Hệ thống Mặt nạ (Mask System)
Thế giới trong game thay đổi trạng thái vật lý dựa trên mặt nạ người chơi đang đeo:
* **`MaskType.NONE`:** Không đeo mặt nạ. Môi trường ở trạng thái cơ bản, nhìn thấy được nhưng không tương tác được với các vật thể màu ảo ảnh.
* **`MaskType.RED`:** Kích hoạt thế giới Đỏ. Các vật thể màu Đỏ hóa rắn và có thể tương tác/va chạm. Các vật thể màu Xanh trở thành ảo ảnh, người chơi đi xuyên qua an toàn.
* **`MaskType.BLUE`:** Kích hoạt thế giới Xanh. Logic ngược lại hoàn toàn với mặt nạ Đỏ.

### 2.2. Hệ thống Sinh tồn (Oxygen)
Thanh Oxy là thước đo sinh mệnh, tiêu hao liên tục và không tự hồi phục:
* **Môi trường bình thường:**
  * Không đeo mặt nạ: Oxy không giảm.
  * Có đeo mặt nạ: Oxy giảm với tốc độ `x1`.
* **Khu vực độc hại (Toxic Zone):**
  * Không đeo mặt nạ: Giảm `x3`.
  * Đeo sai màu mặt nạ: Giảm `x2`.
  * Đeo đúng màu mặt nạ: Giảm `x1`.
* **Hồi phục:** Nhặt các "Bình Oxy" rải rác trong màn chơi.

### 2.3. Cơ chế Di chuyển (Controller)
* **Cơ bản:** Di chuyển trái/phải có gia tốc và nội suy giảm tốc (Friction).
* **Nhảy động (Variable Jump):** Độ cao của cú nhảy phụ thuộc vào thời gian nhấn giữ nút.
* **Lướt (Dash):** Lướt một khoảng ngắn theo phương ngang, vô hiệu hóa trọng lực tạm thời. Mỗi lần lướt tiêu tốn **10 Oxy**.
* **Hỗ trợ điều khiển (QoL):** * *Coyote Time:* Cho phép nhảy ngay cả khi vừa bước hụt khỏi mép nền.
  * *Buffer Jump:* Ghi nhớ thao tác nhảy ngay trước khi chạm đất.
  * *Corner Correcting:* Tự động uốn nắn quỹ đạo nếu đầu nhân vật sượt nhẹ vào góc trần nhà.

### 2.4. Điều kiện Thắng / Thua
* **Mạng sống (Lives):** Khởi điểm với N mạng (Mặc định: 3).
* **Thua (Death):** Chạm phải gai, cạn kiệt Oxy, hoặc rơi xuống vực. Mất 1 mạng và hồi sinh tại Checkpoint gần nhất. Nếu số mạng = 0 ➔ Reset lại toàn bộ màn chơi.
* **Thắng (Victory):** Chạm đến điểm đích (Endpoint) của màn.

---

## 🧱 III. LEVEL OBJECTS

### 3.1. Level Objects
* **Gai (Spikes) - Đỏ / Xanh / Trắng:** Nếu gai đồng màu với mặt nạ (hoặc gai trắng vô hệ), chúng hóa rắn và gây sát thương. Nếu khác màu, chúng mờ đi và trở nên vô hại.
* **Bệ nảy (Jump pads) - Đỏ / Xanh / Trắng:** Khi dẫm lên, đẩy nhân vật lên cao gấp rưỡi (1.5x) so với lực nhảy tối đa.
* **Khu vực độc (Toxic Zone) - Đỏ / Xanh / Đổi màu:** Vùng không gian rút cạn Oxy (giảm x5 lần), đòi hỏi sự linh hoạt trong việc thao tác mặt nạ để giảm thiểu thiệt hại.
* **Bệ đỡ (Platforms) - Đỏ / Xanh / Trắng:** Các khối vật lý để di chuyển, tuân thủ nghiêm ngặt quy tắc của Hệ thống Mặt nạ.
* **Laser:** Gồm 2 màu, người chơi chạm vào là chết, có thể chặn bằng khối kính màu.
* **Kính màu (Colored Glass) - Đỏ / Xanh:** Phản ứng với việc đổi mặt nạ, dùng để chặn tia laser có màu tương ứng, người chơi có thể đi xuyên qua khối này. 

### 3.2. Core Object
* **Bình Oxy (Oxygen Tank):** Hồi phục 25% thanh Oxy tối đa.
* **Điểm lưu (Checkpoint):** Lưu vị trí hồi sinh an toàn cho nhân vật.


---

## 🎨 IV. UI/UX & AESTHETICS

### 4.1. Phong cách Đồ họa
* **Minimalist & High Contrast:** Tập trung vào sự rõ ràng của level design. Màu sắc chủ đạo được giới hạn nghiêm ngặt: **Trắng (Trung lập) - Đỏ - Xanh**.

### 4.2. Giao diện Màn chơi (HUD)
* **Avatar React:** Hình đại diện nhân vật ở góc trên, phản ứng thời gian thực với trạng thái mặt nạ. Rung lắc mạnh/đổi biểu cảm khi lượng Oxy tụt xuống dưới mức cảnh báo (25%).
* **Oxygen Bar:** Thanh tài nguyên đặt ngay cạnh Avatar.
* **Lives Counter:** Hiển thị số mạng sống còn lại.

### 4.3. Menu Hệ thống
* **Main Menu:** Bao gồm các nút điều hướng cơ bản: `Play` (Bắt đầu màn đầu tiên/Tiếp tục), `Settings` (Bảng điều khiển âm lượng, đồ họa), `Quit`.

### 4.4. Game Juice
Trải nghiệm nghe nhìn được đẩy mạnh qua:
* Hiệu ứng hạt (CPUParticles) cho mỗi thao tác dash, đổi mặt nạ, điểm chạm.
* Rung màn hình (Camera Shake) khi nhận sát thương hoặc va chạm mạnh.
* Chuyển cảnh (Screen Transitions) mượt mà giữa các menu và màn chơi.
* **Âm thanh & Nhạc nền:** Phong cách vui nhộn, dồn dập, tăng giảm nhịp độ theo trạng thái hiểm nghèo của Oxy.
