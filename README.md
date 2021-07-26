## Bóc tách âm tiết và trình bày dưới dạng Ascii

### 26/07/2021: Add `wikipedia.txt` <= [source](https://www.kaggle.com/quynd123/vicopus-main)

```sh
cat wikipedia.txt.7z.aa wikipedia.txt.7z.ab > wikipedia.txt.7z
7z x wikipedia.txt.7z
```

- - -

Xem kết quả [`stats\08-telexified_sample.txt`](https://github.com/telexyz/results/blob/master/stats/08-telexified_sample.txt)

### Thuật ngữ

Bảng chữ cái tiếng Việt gồm các ký trơn `a-z` và các ký tự có dấu hoặc có thanh điệu`đáàảãạâấầẩẫậ...`

`dấu (mark)`: là phần mở rộng của ascii như `đ,ư,â ...` gắn liền với ký tự được mở rộng, không thể sai khác.

`thanh điệu (tone)`: là phần trải dài trên vần (âm tiết = âm đầu + vần), và thường được bỏ trên nguyên âm chính. Ví dụ `của vs cuả` là 2 cách bỏ thanh điệu của cùng một âm tiết.

### Các bước phân tách

#### 1/ `alphabet vs nonalphabet`
Phân tách dữ liệu text thành dòng các token thuộc bảng chữ cái và token không thuộc bảng chữ cái.

#### 2/ Lọc `syllable` tokens từ `alphabet` tokens

#### 3/ `alphmark vs alpha0m0t`
Phân tách `alphabet` tokens thành loại có dấu hoặc có thanh điệu (gọi tắt là `alphmark`) và loại trơn (gọi tắt là `alph0m0t`; 0m0t: zero-mark, zero-tone). 

* `alphmark` có thể chứa các âm tiết sai chính tả, viết dính, từ địa phương, từ viết tắt 

* `alph0m0t` thường là từ nước ngoài

#### 4/ Tương tự lọc `syllmark vs syll0m0t` từ `syllable`

* `syllmark` âm tiết tiếng Việt gần như 100%

* `alph0m0t` có thể đa nghĩa vừa là âm tiết TV vừa là từ nước ngoài (`can` trong TV vs `can` trong tiếng Anh)

#### 5/ Lọc `syllow0t` từ `syllable` bằng cách covert thành viết thường, giữ lại dấu và loại bỏ thanh điệu. `syllow0t`: có nghĩa là âm tiết (syll), viết thường (lower), và không thanh điệu (0t: zero-tone).

### Trình bày lại dưới dạng Ascii

#### Các từ không phải âm tiết tiếng Việt có 2 lựa chọn:

##### 1/ Loại bỏ và tách các cụm âm tiết tiếng Việt liền nhau theo dòng
`./bin/telexifiy input.txt output.xyz`

##### 2/ Giữ lại nguyên bản
`./bin/telexifiy input.txt output.xyz keep`

#### Với các âm tiết tiếng Việt 
```js
* Nước => ^nuoc|ws
* VIỆT => ^^viet|zj
* đầy  => dday|zf
```
##### 1/ Dùng `^` đánh dấu âm tiết viết hoa chữ cái đầu, `^^` viết hoa toàn bộ
Note: bỏ qua trường hợp viết cả thường lẫn hoa như `MóNg`

##### 2/ Chuyển phần dấu nguyên âm và thanh về cuối âm tiết:

###### 2.1/ Phần dấu
* `w` cho cách bỏ dấu `ă,ư,ơ,ươ,ưa`

* `z` cho cách bỏ dấu `â,ê,ô,uô,iê,yê`

###### 2.2/ Phần thanh điệu
* `s|f|r|x|j` cho các thanh sắc, huyền, hỏi, ngã, nặng

Cách trình bày lại này linh động ở chỗ giữ nguyên dạng cách viết không dấu không thanh, bóc tách thuộc tính viết hoa thành tiền tố `^`, bóc tách phần dấu và thanh điệu, là bổ xung cho cách viết không dấu, thành hậu tố `|[wz][sfrxj]`. 

#### ƯU ĐIỂM

Nói về ưu điểm dưới góc nhìn của việc xử lý và lưu trữ dữ liệu (a.k.a góc nhìn máy tính)

1. Cách trình bày này bao hàm luôn cách gõ không dấu không thanh vì âm tiết không dấu không thanh luôn là sub-string của âm tiết đầy đủ. Giúp dễ tìm kiếm, đối chiếu hơn.

2. Gõ sao (cố gắng) lưu vậy (key-strokes -> chars). Cách lưu trữ cũng là cách gõ telex khác để làm luật chặt chẽ hơn:
* Viết không dấu trước
* Chỉ bỏ dấu và thanh ở cuối từ
* Dùng `z` để bỏ dấu `â,ô,ê` (như `w` với dấu `ơ,ă,ư`) thay vì cách gõ `aa,oo,ee`

	Ví dụ: Gõ `motzj` => `một`, `nguoiwf` => `người` ..

	Cách gõ Telex có ưu điểm lớn nhất là chỉ sử dụng key-stroke cơ bản `a-z` nên tốc độ gõ nhanh và hỗ trợ tốt trong nhiều hoàn cảnh (ví dụ trên bàn phím smartphone, dãy chữ số thường bị ẩn đi ...) 

	Đó là một ví dụ của việc đặt ra "luật" rõ-ràng, có-mục-đích từ đầu sẽ hỗ trợ cho toàn bộ quá trình về sau. Triển khai luật này, công thêm định hướng làm sao cho gõ nhanh, không phải nhìn bàn phím, không bị lẫn phím dấu, thanh với phím phụ âm, nguyên âm ta có cách gõ Telex đơn giản và dễ nhớ như sau: `dd=đ; aw,uw,ow=ă,ư,ơ; aa,oo,ee=â,ô,ê`, `sfrxj` cho thanh điệu sắc, huyền, hỏi, ngã nặng. Cách triển khai này tuân thủ luật gốc và cố gắng tối ưu cho việc gõ nhanh nhất có thể. Các cách gõ bổ trợ khác như gõ nhanh `cc=ch,gg=gi,nn=ng,qq=qu,pp=ph,th=th`, gõ tắt phụ âm đầu `f=ph,j=gi,w=qu`, gõ tắt phụ âm cuối `g=ng,h=nh,k=ch` là mở rộng thêm theo hướng tối ưu cho tốc độ đó.

	Việc làm luật gõ chặt chẽ hơn như chỉ bỏ dấu và thanh ở cuối âm tiết tối ưu cho mục đích khác là giúp bộ gõ dự đoán tình huống tốt hơn, phân biệt tiếng Việt với tiếng nước ngoài dễ hơn. Ví dụ khi máy nhận được nguyên âm `ie,ye` chắc chắn phần dấu chỉ là `z`->`iê,yê`, tương tự `uan` chỉ có thể là `z`->`uân`(máy có thể dự đoán được vì người dùng đã gõ tới phụ âm cuối vần `n`). Chỉ dùng 1 ký tự `z` thay vì `aa,ee,oo` sẽ làm luật nhất quán hơn vì cũng giống như dùng `w` cho `aw,ow,uw`, dễ phân biệt tới từ tiếng anh như `teen, toon ...` và cả với tiếng Việt như âm `boong` chẳng hạn ... Tuy ít gặp nhưng cũng là một âm tiết tiếng Việt có ý nghĩa rõ ràng.

	Nhìn từ góc độ này thì việc làm lỏng luật hơn để việc gõ tiếng Việt nhanh hơn chút ít như gõ nhanh `cc=ch,gg=gi,nn=ng,qq=qu,pp=ph,th=th`, gõ tắt phụ âm đầu `f=ph,j=gi,w=qu`, gõ tắt phụ âm cuối `g=ng,h=nh,k=ch`, cùng với cách gõ bỏ dấu tự do (ở bất kỳ đâu sau nguyên âm) mặc dù tiện hơn đấy nhưng làm khó cho máy tính trong việc đoán người dùng đang gõ từ tiếng Việt hay đang gõ từ nước ngoài (tiếng Anh chẳng hạn). 

	Mình đi ngược lại trào lưu này vì cho rằng nhiều luật làm cho khó nhớ, dễ lẫn và làm khó cho người lập trình cũng như máy tính. Mình gõ tiếng Việt pha lẫn tiếng Anh nhiều nên sau một thời gian thử đã tắt hết các luật mở rộng để hạn chế nhầm lẫn.

3. Phần hậu tố này có thể làm nhãn (tag) để huấn luyện máy học cách tự động bỏ dấu ...

4. Khi tách âm tiết bất kỳ thành `tiền tố + âm tiết không dấu viết thường + hậu tố`: `^^ + viet + |zj` (gửi thông tin vào ngữ cảnh) sẽ làm giảm bộ từ vựng (vocab) chỉ còn còn khoảng < 3000 (xem file `az_syll0m0ts.txt`). Lợi cho việc huấn luyện với tập dữ liệu nhỏ hoặc tài nguyên hạn chế.

5. Việc sắp xếp cũng đơn giản hơn, ko có chuyện a, ă, â đứng cách xa nhau hàng km. 

6. Tính toán độ giống nhau (similarity) để chữa lỗi chính tả do gõ bàn phím cũng dễ hơn vì lỗi dễ nắm bắt nhất là ở ngay lúc gõ phím chứ không phải ở bản thân ký tự (ascii hay utf-8). Đây là một lợi điểm nữa của `2. Gõ sao (cố gắng) lưu vậy` bằng việc dùng ascii để trình bày thay vì utf-8 vì ascii gần bàn phím (key-stroke) hơn utf-8.


#### YẾU ĐIỂM

Với người dùng: đó là khó đọc hơn utf-8, tuy đã dễ đọc hơn một chút so với kiểu ascii-telex `muoi|wf vs muwowif`

Tóm lại là 1 cách trình bày chuẩn và đúng đắn sẽ phát huy được ưu điểm trong phần lớn các tác vụ, giúp người lập trình và máy tính tối ưu trong việc xử lý và hỗ trợ người dùng. Cách trình bày này hướng tới điều đó.