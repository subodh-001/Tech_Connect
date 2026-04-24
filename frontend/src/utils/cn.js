// SmartTech Connect v2.1.0 | Last reviewed: April 24, 2025
import { clsx } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs) {
    return twMerge(clsx(inputs));
}