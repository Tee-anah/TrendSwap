;; TrendSwap: P2P Fashion Exchange Protocol
;; Version: 1.0.0

(define-constant ERR-NOT-AUTHORIZED (err u1))
(define-constant ERR-LISTING-NOT-FOUND (err u2))
(define-constant ERR-ALREADY-LISTED (err u3))
(define-constant ERR-INVALID-STATUS (err u4))

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
        (map-set listings listing-id {
            owner: tx-sender,
            item-name: item-name,
            description: description,
            size: size,
            category: category,
            status: "active",
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
        (asserts! (is-eq (get status listing) "active") ERR-INVALID-STATUS)
        (ok (map-set listings listing-id (merge listing { status: "cancelled" })))
    )
)

(define-read-only (get-listing (listing-id uint))
    (ok (map-get? listings listing-id))
)

(define-read-only (get-owner (listing-id uint))
    (ok (get owner (unwrap! (map-get? listings listing-id) ERR-LISTING-NOT-FOUND)))
)