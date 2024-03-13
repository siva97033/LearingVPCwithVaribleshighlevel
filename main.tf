resource "aws_vpc" "TerraformVpc" {
  cidr_block = var.vpccidr
  tags = merge(var.commontags,
    {
      Name = "testvpc"
    }
  )
}

resource "aws_subnet" "publicsubnets" {
  vpc_id     = aws_vpc.TerraformVpc.id
  count      = length(var.publicsubnetscidr)
  cidr_block = element(var.publicsubnetscidr, count.index)
  tags = merge(var.commontags,
    {
      Name = "TerraformVpc_publicsubnets-${count.index}"
    }
  )
  availability_zone = element(var.az, count.index)

}

resource "aws_subnet" "privatesubnets" {
  vpc_id     = aws_vpc.TerraformVpc.id
  count      = length(var.privatesubnetscidr)
  cidr_block = element(var.privatesubnetscidr, count.index)
  tags = merge(var.commontags,
    {
      Name = "TerraformVpc_privatesubnet-${count.index}"
    }
  )
  availability_zone = element(var.az, count.index)

}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.TerraformVpc.id
  tags = merge(var.commontags,
    {
      Name = "TerraformVpc_IGW"
    }
  )

}
resource "aws_eip" "EIP" {
  tags = merge(var.commontags,
    {
      Name = "TerraformVpc_EIP"
    }
  )

}


resource "aws_nat_gateway" "NAT" {
  subnet_id     = element(aws_subnet.publicsubnets[*].id, 1)
  allocation_id = aws_eip.EIP.id
  depends_on    = [aws_internet_gateway.IGW]
  tags = merge(var.commontags,
    {
      Name = "TerraformVpc_NAT"
    }
  )
}

resource "aws_route_table" "purt" {
  vpc_id = aws_vpc.TerraformVpc.id
  route  {
    cidr_block= var.route1
    gateway_id= aws_internet_gateway.IGW.id

  }
  tags = merge(var.commontags,
    {
      Name = "TerraformVpc_purt"
    }
  )
  
}

resource "aws_route_table_association" "purtasso" {
  count = length(aws_subnet.publicsubnets)
  subnet_id = element(aws_subnet.publicsubnets[*].id, count.index)
  route_table_id = aws_route_table.purt.id

  
}

resource "aws_route_table" "prrt" {
  vpc_id = aws_vpc.TerraformVpc.id
  route  {
    cidr_block= var.route2
    gateway_id= aws_nat_gateway.NAT.id

  }
  
}
resource "aws_route_table_association" "prrtasso" {
  count = length(aws_subnet.privatesubnets)
  subnet_id = element(aws_subnet.privatesubnets[*].id, count.index)
  route_table_id = aws_route_table.prrt.id

  
}


