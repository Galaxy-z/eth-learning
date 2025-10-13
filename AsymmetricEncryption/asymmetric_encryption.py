import hashlib
from dataclasses import dataclass

from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import padding, rsa


# 使用 RSA 非对称加密演示：包含 POW（工作量证明）、签名与验签流程
DIFFICULTY = 4  # number of leading hex zeros required in the POW hash
NICKNAME = "galaxy"  # replace with your nickname if desired


@dataclass
class PowResult:
	nonce: int
	digest: str


def solve_pow(nickname: str, difficulty: int = DIFFICULTY) -> PowResult:
	# 按难度查找满足前缀全为零的哈希值
	prefix = "0" * difficulty
	nonce = 0

	while True:
		payload = f"{nickname}{nonce}".encode()
		digest = hashlib.sha256(payload).hexdigest()
		if digest.startswith(prefix):
			return PowResult(nonce=nonce, digest=digest)
		nonce += 1


def generate_rsa_keypair() -> tuple[rsa.RSAPrivateKey, rsa.RSAPublicKey]:
	# 生成 2048 位 RSA 公私钥
	private_key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
	return private_key, private_key.public_key()


def sign_payload(private_key: rsa.RSAPrivateKey, payload: bytes) -> bytes:
	# 使用私钥对消息进行 PSS 填充的 SHA-256 签名
	return private_key.sign(
		payload,
		padding.PSS(mgf=padding.MGF1(hashes.SHA256()), salt_length=padding.PSS.MAX_LENGTH),
		hashes.SHA256(),
	)


def verify_signature(public_key: rsa.RSAPublicKey, payload: bytes, signature: bytes) -> None:
	# 使用公钥验证签名，验证失败会抛出异常
	public_key.verify(
		signature,
		payload,
		padding.PSS(mgf=padding.MGF1(hashes.SHA256()), salt_length=padding.PSS.MAX_LENGTH),
		hashes.SHA256(),
	)


def to_pem(private_key: rsa.RSAPrivateKey, public_key: rsa.RSAPublicKey) -> tuple[str, str]:
	# 将密钥转换为 PEM 文本方便保存或展示
	private_pem = private_key.private_bytes(
		encoding=serialization.Encoding.PEM,
		format=serialization.PrivateFormat.TraditionalOpenSSL,
		encryption_algorithm=serialization.NoEncryption(),
	).decode()

	public_pem = public_key.public_bytes(
		encoding=serialization.Encoding.PEM,
		format=serialization.PublicFormat.SubjectPublicKeyInfo,
	).decode()

	return private_pem, public_pem


def main() -> None:
	# 主流程：生成密钥、计算 POW、签名并验证
	print("Generating RSA key pair...")
	private_key, public_key = generate_rsa_keypair()

	print(f"Solving POW for nickname '{NICKNAME}' with difficulty {DIFFICULTY}...")
	pow_result = solve_pow(NICKNAME, DIFFICULTY)
	payload = f"{NICKNAME}{pow_result.nonce}".encode()

	print(f"Found nonce: {pow_result.nonce}")
	print(f"SHA-256 digest: {pow_result.digest}")

	print("Signing payload with private key...")
	signature = sign_payload(private_key, payload)
	print(f"Signature (hex): {signature.hex()}")

	print("Verifying signature with public key...")
	verify_signature(public_key, payload, signature)
	print("Signature verified successfully.")

	private_pem, public_pem = to_pem(private_key, public_key)
	print("\nPrivate Key (PEM):\n", private_pem)
	print("Public Key (PEM):\n", public_pem)


if __name__ == "__main__":
	main()

