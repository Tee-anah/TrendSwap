;; TrendSwap: P2P Fashion Exchange Protocol
;; Version: 1.0.0

(define-constant ERR-NOT-AUTHORIZED (err u1))
(define-constant ERR-LISTING-NOT-FOUND (err u2))
(define-constant ERR-ALREADY-LISTED (err u3))
(define-constant ERR-INVALID-STATUS (err u4))
(define-constant ERR-INVALID-PRICE (err u5))
(define-constant ERR-INVALID-SIZE (err u6))
(define-constant ERR-INVALID-CATEGORY (err u7))
(define-constant ERR-INVALID-NAME (err u8))
(define-constant ERR-INVALID-DESCRIPTION (err u9))
(define-constant MIN-PRICE u1)

(define-data-var next-listing-id uint u1)

(define-map listings
    uint
    {
        owner: principal,
        item-name: (string-utf8 50),
        description: (string-utf8 200),
        size: (string-utf8 10),
        category: (string-utf8 20),
        status: (string-utf8 10),
        price: uint
    }
)

(define-private (validate-size (size (string-utf8 10)))
    (or 
        (is-eq size u"XS")
        (is-eq size u"S")
        (is-eq size u"M")
        (is-eq size u"L")
        (is-eq size u"XL")
        (is-eq size u"XXL")
    )
)

(define-private (validate-category (category (string-utf8 20)))
    (or 
        (is-eq category u"Tops")
        (is-eq category u"Bottoms")
        (is-eq category u"Dresses")
        (is-eq category u"Shoes")
        (is-eq category u"Accessories")
    )
)

(define-private (validate-text-length (text (string-utf8 200)) (min-length uint) (max-length uint))
    (let 
        (
            (text-length (len text))
        )
        (and 
            (>= text-length min-length)
            (<= text-length max-length)
        )
    )
)

(define-public (create-listing 
    (item-name (string-utf8 50))
    (description (string-utf8 200))
    (size (string-utf8 10))
    (category (string-utf8 20))
    (price uint)
)
    (let
        (
            (listing-id (var-get next-listing-id))
        )
        (asserts! (validate-text-length item-name u3 u50) ERR-INVALID-NAME)
        (asserts! (validate-text-length description u10 u200) ERR-INVALID-DESCRIPTION)
        (asserts! (>= price MIN-PRICE) ERR-INVALID-PRICE)
        (asserts! (validate-size size) ERR-INVALID-SIZE)
        (asserts! (validate-category category) ERR-INVALID-CATEGORY)
        
        (map-set listings listing-id {
            owner: tx-sender,
            item-name: item-name,
            description: description,
            size: size,
            category: category,
            status: u"active",
            price: price
        })
        (var-set next-listing-id (+ listing-id u1))
        (ok listing-id)
    )
)

(define-public (cancel-listing (listing-id uint))
    (let
        (
            (listing (unwrap! (map-get? listings listing-id) ERR-LISTING-NOT-FOUND))
        )
        (asserts! (is-eq tx-sender (get owner listing)) ERR-NOT-AUTHORIZED)
        (asserts! (is-eq (get status listing) u"active") ERR-INVALID-STATUS)
        (ok (map-set listings listing-id (merge listing { status: u"cancel" })))
    )
)

(define-read-only (get-listing (listing-id uint))
    (ok (map-get? listings listing-id))
)

(define-read-only (get-owner (listing-id uint))
    (ok (get owner (unwrap! (map-get? listings listing-id) ERR-LISTING-NOT-FOUND)))
)