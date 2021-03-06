
# Author: Jonathon Love

toB64Lookup <- c(
  0x41,   # A
  0x42,   # B
  0x43,   # C
  0x44,   # D
  0x45,   # E
  0x46,   # F
  0x47,   # G
  0x48,   # H
  0x49,   # I
  0x4A,   # J
  0x4B,   # K
  0x4C,   # L
  0x4D,   # M
  0x4E,   # N
  0x4F,   # O
  0x50,   # P
  0x51,   # Q
  0x52,   # R
  0x53,   # S
  0x54,   # T
  0x55,   # U
  0x56,   # V
  0x57,   # W
  0x58,   # X
  0x59,   # Y
  0x5A,   # Z
  0x61,   # a
  0x62,   # b
  0x63,   # c
  0x64,   # d
  0x65,   # e
  0x66,   # f
  0x67,   # g
  0x68,   # h
  0x69,   # i
  0x6A,   # j
  0x6B,   # k
  0x6C,   # l
  0x6D,   # m
  0x6E,   # n
  0x6F,   # o
  0x70,   # p
  0x71,   # q
  0x72,   # r
  0x73,   # s
  0x74,   # t
  0x75,   # u
  0x76,   # v
  0x77,   # w
  0x78,   # x
  0x79,   # y
  0x7A,   # z
  0x30,   # 0
  0x31,   # 1
  0x32,   # 2
  0x33,   # 3
  0x34,   # 4
  0x35,   # 5
  0x36,   # 6
  0x37,   # 7
  0x38,   # 8
  0x39,   # 9
  0x2E,   # .
  0x5F)   # _

fromB64Lookup <- c(
  rep(-1, 0x2D),
  63,
  -1,
  0x35:0x3E,  # 0x30
  rep(-1, 0x40 - 0x3A + 1),
  1:26,  # 0x41
  rep(-1, 0x5E - 0x5B + 1), # 0x5B
  64, # 0x5F
  -1, # 0x60
  1:26+26,
  rep(-1, 0x7F - 0x7A + 1))

toB64 <- function(names) {
  sapply(names, toB64string, USE.NAMES=FALSE)
}

fromB64 <- function(names) {
  sapply(names, fromB64string, USE.NAMES=FALSE)
}

fromB64string <- function(string) {

  if ( ! startsWith(string, '.'))
    stop('b64 names should begin with a dot')

  string <- substring(string, 2)

  if (string == "")
    return("")

  array <- as.integer(charToRaw(string))
  array <- fromB64Lookup[array] - 1

  out <- c()

  i <- 1
  j <- 1

  while (i <= length(array)) {

    if (i + 1 <= length(array))
      out[j + 0] <- 4  *  array[i + 0] + floor(array[i + 1] / 16)
    else
      out[j + 0] <- 4  *  array[i + 0]

    if (i + 2 <= length(array))
      out[j + 1] <- 16 * (array[i + 1] %% 16) + as.integer(array[i + 2] / 4)
    if (i + 3 <= length(array))
      out[j + 2] <- 64 * (array[i + 2] %% 4) + array[i + 3]

    i <- i + 4
    j <- j + 3
  }

  rawToChar(as.raw(out))
}


toB64string <- function(string) {

  if (string == "")
    return("")

  array <- as.integer(charToRaw(string))

  out <- c()

  i <- 1
  j <- 1

  while (i <= length(array)) {

    out[j + 0] <- floor(array[i + 0] / 4)

    if (i + 1 <= length(array)) {

      out[j + 1] <- (array[i + 0] %% 4) * 16 + floor((array[i + 1] / 16))

      if (i + 2 <= length(array)) {

        out[j + 2] <- (array[i + 1] %% 16) * 4 + floor(array[i + 2] / 64)
        out[j + 3] <- array[i + 2] %% 64
      }
      else {

        out[j + 2] <- (array[i + 1] %% 16) * 4
      }
    }
    else {

      out[j + 1] <- (array[i + 0] %% 4) * 16
    }

    i <- i + 3
    j <- j + 4
  }

  chars <- toB64Lookup[out + 1]

  paste0('.', rawToChar(as.raw(chars)))
}
