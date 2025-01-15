import sys

# This script intends to grab all raw yaml downloads and transform them 
# into something that can be easily put into aws-access

def main():
    if len(sys.argv) != 2 or not sys.argv[1].isdigit():
        print("Usage: reformat_to_aws_access.py <account_id>")
        sys.exit(1)
    
    account_id = sys.argv[1]
    print(f"Processing account ID: {account_id}")

    # to make an account file we need

    # Account number (stdin)
    # Account name (stdin)

    # roles > users
     




if __name__ == "__main__":
    main()