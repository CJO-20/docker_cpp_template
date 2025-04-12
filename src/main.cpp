#include <iostream>
#include <thread>
#include <mutex>
#include <atomic>
#include <vector>
#include <chrono>
#include <cstring>

inline std::mutex print_mutex;
inline std::atomic_uint64_t shared_counter(0ull);

void task (size_t thread_index)
{
    std::unique_lock<std::mutex> print_lock(print_mutex, std::defer_lock);

    for (size_t i = shared_counter.fetch_add(1ull, std::memory_order_acquire); i < 100ull; i = shared_counter.fetch_add(1ull, std::memory_order_acq_rel))
    {
        print_lock.lock();
        std::cout << "Thread " << thread_index << " has consumed " << i << ".\n";
        print_lock.unlock();

        std::this_thread::sleep_for(std::chrono::milliseconds(1));
    }
}

int main (const int argc, const char * argv[])
{
    const size_t pool_size = std::thread::hardware_concurrency();
    std::vector<std::thread> thread_pool;

    thread_pool.reserve(pool_size);

    for (size_t i = 0ull; i < pool_size; i++)
    {
        thread_pool.emplace_back(task, i);
    }

    for (size_t i = 0ull; i < pool_size; i++)
    {
        thread_pool[i].join();
    }

    std::cout << "Tasks are done!" << std::endl;
    return 0;
}
