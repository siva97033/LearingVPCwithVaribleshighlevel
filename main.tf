resource "aws_vpc" "demovpc" {
  cidr_block = var.vpccidr
  tags = merge(var.commontags,
    {
      Name = "testvpc"

    },
  )

}

resource "aws_subnet" "publicsubntes" {
  vpc_id = aws_vpc.demovpc.id
  cidr_block = element(var.publicsubnetcidr, count.index)
  count  = length(var.publicsubnetcidr)
  

  tags = merge(var.commontags,
    {
      Name = "testvpcpublicsubnet-${count.index}"
    },
  )
  availability_zone = element(var.az, count.index)
}
resource "aws_subnet" "privatesubnets" {
  vpc_id = aws_vpc.demovpc.id
  cidr_block = element(var.privatesubnetcidr, count.index)
  count  = length(var.privatesubnetcidr)
  tags = merge(var.commontags,
    {
      Name = "testvpcprivatesubnet-${count.index}"
    }

  )
  availability_zone = element(var.az, count.index)

}
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.demovpc.id
  tags = merge(var.commontags,
    {
      Name = "testvpcIGW"
    },
  )

}

resource "aws_route_table" "publicrt" {
  vpc_id = aws_vpc.demovpc.id
  route {
    cidr_block = var.route1
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = merge(var.commontags,
    {
      Name = "testvpcpubliccrt"
    },
  )
}

resource "aws_route_table_association" "publiccrtasso" {
  count = length(aws_subnet.publicsubntes)
  route_table_id = aws_route_table.publicrt.id
  
  subnet_id      = element(aws_subnet.publicsubntes[*].id, count.index)

}

resource "aws_eip" "eip" {
  tags = merge(var.commontags,
    {
      Name = "testvpcEIP"
    },
  )


}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = element(aws_subnet.publicsubntes[*].id, 1)
  tags = merge(var.commontags,
    {
      Name = "testvpcnat"
    },
  )
  depends_on = [aws_internet_gateway.IGW]

}

resource "aws_route_table" "privatecrt" {
  vpc_id = aws_vpc.demovpc.id
  route {
    cidr_block = var.route2
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = merge(var.commontags,
    {
      Name = "testvpcprivatecrt"
    },
  )



}

resource "aws_route_table_association" "privatecrtasso" {
  count = length(aws_subnet.privatesubnets)
  route_table_id = aws_route_table.privatecrt.id
  subnet_id      = element(aws_subnet.privatesubnets[*].id, count.index)

}
