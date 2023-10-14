import rsa


def generate_api_keys(file_key: str = "gcapi") -> None:
    (pub_key, pvt_key) = rsa.newkeys(512)
    private_pem = pub_key.save_pkcs1().decode()
    public_pem = pvt_key.save_pkcs1().decode()
    with open(f"./certs/{file_key}_private_key.pem", "w") as pr:
        pr.write(private_pem)
    with open(f"./certs/{file_key}_public_key.pem", "w") as pu:
        pu.write(public_pem)


if __name__ == "__main__":
    generate_api_keys("gcapi")
